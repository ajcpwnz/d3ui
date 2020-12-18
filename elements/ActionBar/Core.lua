local CActionBar = {}

function CActionBar:CreateFrame()
    local frame = CreateFrame("Button", 'd3ui_ActionBar_' ..self.index, d3ui_Superframe, "SecureHandlerStateTemplate")
    frame:EnableMouse(true)
    frame:RegisterForClicks("AnyUp")
    frame:Show()

    frame:SetAttribute("_onstate-page", [[

        local st = newstate
        if(st == 'override') then
            if HasVehicleActionBar() then
                st = GetVehicleBarIndex()
            elseif HasOverrideActionBar() then
                st = GetOverrideBarIndex()
            elseif HasTempShapeshiftActionBar() then
				newstate = GetTempShapeshiftBarIndex()
            end
        end

        control:ChildUpdate("state", st)
        self:SetAttribute('tabref', st)
    ]])

    RegisterStateDriver(frame, "page", '[overridebar][possessbar][shapeshift]override;[bonusbar:3]4;[bonusbar:1,stealth:1]5;[bonusbar:1]6;0')

    self.frame = frame
end

function CActionBar:CreateButtons()
    local buttons = {}

    for i = 1, CONSTS.ACTION_BARS.BUTTON_LIMIT do
        if(not self.config.buttons[i]) then
            self.config.buttons[i] = d3ui_ActionBarEmptyButton
        end

        local btn = d3ui_ActionButtonCreate(self.index, i, self)

        btn:ApplyConfig(self.config.buttons[i])

        buttons[i] = btn
    end

    self.buttons = buttons
end

function CActionBar:UpdateButtons()
    local buttons = {}

    for i = 1, CONSTS.ACTION_BARS.BUTTON_LIMIT do
        if(not self.config.buttons[i]) then
            self.config.buttons[i] = deepcopy(d3ui_ActionBarEmptyButton)
        end

        local btn = self.buttons[i]
        btn:ApplyConfig(self.config.buttons[i])
    end
end


function CActionBar:Load()
    self:CreateFrame()
end



function CActionBar:ApplyConfig(config, secure)
    self.config = config
    if(not InCombatLockdown()) then
        if(config.DISPLAY.ORIENTATION == 'HORIZONTAL') then
            self.frame:SetSize(config.DISPLAY.SIZE, (config.DISPLAY.SIZE * config.length) + (config.DISPLAY.SPACE * (config.length - 1)))
        else
            self.frame:SetSize((config.DISPLAY.SIZE * config.length) + (config.DISPLAY.SPACE * (config.length - 1)), config.DISPLAY.SIZE)
        end
        self.frame:SetPoint(config.DISPLAY.POINT, config.DISPLAY.X, config.DISPLAY.Y)
    end

    if(self.config.DISPLAY.MODEST) then
        self.frame:SetAlpha(0)
        self.frame:SetScript("OnEnter", function() self.frame:SetAlpha(1) end)
        self.frame:SetScript("OnLeave", function() self.frame:SetAlpha(0) end)
    end
    --self:CreateButtons()
end

function CActionBar:Construct(i)
    local inst = { index = i}

    setmetatable(inst, self)
    self.__index = self

    return inst
end

IActionBar = CreateFrame('Frame')
IActionBar.bars = {}

function IActionBar:AddEventHandlers()
    local inst = self
    local events = {}

    function events:PLAYER_SPECIALIZATION_CHANGED()
        inst:UpdateUnitProps()
        inst:UpdateBars()
    end

    UTIL:RegisterEvents(self, events)
end

function IActionBar:UpdateUnitProps()
    -- TODO: This will cause errors if characters have same names on different realms.
    local name = UnitFullName('player', true)
    -- TODO: This will error if fired after shapeshift when name is affected
    local spec = GetSpecialization()

    self.props = { name = name, spec = spec}
end

function IActionBar:CreateDefaultConfig()
    local barConfig = {}
    local defaultOffset = - 34
    for i = 1, CONSTS.ACTION_BARS.BAR_LIMIT do
        if(d3ui_ActionBarDefaultConf[i]) then
            barConfig[i] = deepcopy(d3ui_ActionBarDefaultConf[i])
        else
            local emptyBar = deepcopy(d3ui_ActionBarEmptyBar)
            defaultOffset = defaultOffset - emptyBar.DISPLAY.SIZE
            emptyBar.DISPLAY.Y = defaultOffset
            barConfig[i] = emptyBar
        end
    end
    return barConfig
end

function IActionBar:GetOrCreateConfig()
    local barData = d3ui_Data.ActionBars
    local barConfig = {}
    local ret = {}

    if(barData[self.props.name]) then
        barConfig = barData[self.props.name]

        if(barConfig[self.props.spec]) then
            ret = barConfig[self.props.spec]
        else
            ret = self:CreateDefaultConfig()
            barConfig[self.props.spec] = ret
        end
    else
        ret = self:CreateDefaultConfig()
        barData[self.props.name] = {[self.props.spec] = ret }
    end

    return ret
end

function IActionBar:CreateBars()
    local config = self:GetOrCreateConfig()

    for i = 1, CONSTS.ACTION_BARS.BAR_LIMIT do
        local bar = CActionBar:Construct(i)
        bar:Load()
        bar:ApplyConfig(config[i])
        bar:CreateButtons()

        self.bars[i] = bar
    end
end

function IActionBar:UpdateBars()
    local config = self:GetOrCreateConfig()

    for i = 1, CONSTS.ACTION_BARS.BAR_LIMIT do
        local bar = self.bars[i]
        bar:ApplyConfig(config[i])
        bar:UpdateButtons()
    end
end

function IActionBar:Load()
    if(not d3ui_Data) then
       print('Warning: No data accessor') -- Shouldn't happen though
    end

    if(not d3ui_Data.ActionBars) then
       print('Weak Warning: Defaulting d3ui action bars')
       d3ui_Data.ActionBars = {}
    end
    -- end silly dump

    self:UpdateUnitProps()
    self:CreateBars()

    self:AddEventHandlers()
end

