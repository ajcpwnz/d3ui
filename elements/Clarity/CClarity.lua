local TICKINTERVAL = 0.3333

ClarityGlobalState = {
    combat = {
        tail = 1,
        subs = {}
    },
    always = {
        tail = 1,
        subs = {}
    },
    dead = {
        tail = 1,
        subs = {}
    },
}

IClarity  = {
    states = {
        combat = nil,
        always = nil,
        dead = nil
    },
    dirtyStates = {
        gcd = 0,
    },
    timerElapsed = 0
}

local eventTemplates = {}


function ClarityGlobalState:Subscribe(dependencies, handler)
    local dependencyMapping = {}

    for dep, _ in pairs(dependencies) do
        if(not ClarityGlobalState[dep]) then
            ClarityGlobalState[dep] = {subs = {}, tail = 1}
        end

        local tail = ClarityGlobalState[dep].tail
        ClarityGlobalState[dep].subs[tail] = handler
        ClarityGlobalState[dep].tail = ClarityGlobalState[dep].tail + 1
        dependencyMapping[dep] = tail
    end

    return dependencyMapping
end

function ClarityGlobalState:Dispatch(field, value)
    if(IClarity.states[field] == value) then return end;

    IClarity.states[field] = value
    for index = 1, ClarityGlobalState[field].tail - 1 do
        if(ClarityGlobalState[field].subs[index]) then
            local stateSnapshot = IClarity.states
            ClarityGlobalState[field].subs[index](stateSnapshot, ContextMap:ExtractContext(field, index))
        else
            print('[Clarity warning] Could not find handler for field '.. field..', at index '.. index)
        end
    end
end



function IClarity:CreateFrame()
    --d3ui_ClaritySuperframe:SetBackdrop({ edgeFile = 'Interface\\AddOns\\d3ui\\inc\\border-solid-2.blp', edgeSize = 4})

    d3ui_ClaritySuperframe:SetSize(700, 100)
    d3ui_ClaritySuperframe:SetPoint('CENTER', 0, 135)
    d3ui_ClaritySuperframe:Show()
end

function IClarity:PlugConfig(config)
    for k, actor in pairs(config) do
        local dependencyMapping = ClarityGlobalState:Subscribe(actor.depends, actor.handler)

        if(actor.createCtx) then
            local contextShard = actor.createCtx()
            for field, tail in pairs(dependencyMapping) do
                if(not ContextMap[field]) then
                    ContextMap[field] = {}
                end
                ContextMap[field][tail] = contextShard
            end
        end

        if(actor.actions) then
           for _, action in pairs(actor.actions) do
               local event = action.event
               if(not eventTemplates[event]) then
                   eventTemplates[event] = {tail = 1, queue = {}}
               end
               eventTemplates[event].queue[eventTemplates[event].tail] = action.action
               eventTemplates[event].tail = eventTemplates[event].tail + 1
           end
        end

        if(actor.intialize) then
           actor.initialize()
        end
    end
end

function IClarity:LoadConfigs()
    local _, _, classToken = UnitClass('player')

    if(not CLARITY_CONFIGS[classToken]) then return end;

    local classConfig = CLARITY_CONFIGS[classToken]
    local specConfig = {}
    local specToken = GetSpecialization()

    if(classConfig.SPECS[specToken]) then
       specConfig = classConfig.SPECS[specToken]
    end

    IClarity:PlugConfig(classConfig.SHARED)
    IClarity:PlugConfig(specConfig)
end

function IClarity:HitWithStick()
    ClarityGlobalState:Dispatch('always', 1)
    ClarityGlobalState:Dispatch('dead', UnitIsDead('player'))

    local _1, gcdDuration = GetSpellCooldown(61304)
    IClarity.dirtyStates.gcd = gcdDuration or 0
end

function IClarity:AddEventHandlers()
    local events = {}

    function events:PLAYER_REGEN_DISABLED()
        ClarityGlobalState:Dispatch('combat', true)
    end

    function events:PLAYER_REGEN_ENABLED()
        ClarityGlobalState:Dispatch('combat', false)
        ClarityGlobalState:Dispatch('always', 1)
        IClarity.timerElapsed = 0
    end

    function events:PLAYER_DEAD()
        ClarityGlobalState:Dispatch('dead', UnitIsDead('player'))
    end
    function events:PLAYER_ALIVE()
        ClarityGlobalState:Dispatch('dead', UnitIsDead('player'))
    end

    for k, v in pairs(eventTemplates) do
        events[k] = function ()
            for _, action in pairs(v.queue) do
                action()
            end
        end
    end

    UTIL:RegisterEvents(d3ui_ClaritySuperframe, events)

    d3ui_ClaritySuperframe:HookScript("OnUpdate", function(self, elapsed)
        if(not IClarity.states.combat) then return end;
        IClarity.timerElapsed = IClarity.timerElapsed + elapsed
        if(IClarity.timerElapsed > TICKINTERVAL) then
            local _1, gcdDuration = GetSpellCooldown(61304)
            IClarity.dirtyStates.gcd = gcdDuration or 0

            IClarity.timerElapsed = 0
            ClarityGlobalState:Dispatch('always', IClarity.states.always + 1)
        end
    end)
end

function IClarity:Load ()
    IClarity:CreateFrame()
    IClarity:LoadConfigs()

    IClarity:AddEventHandlers()


    IClarity:HitWithStick()
end


d3ui.Clarity = IClarity