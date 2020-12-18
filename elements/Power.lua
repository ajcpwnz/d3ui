IPowerDisplay = {
    frame = {},

    power_type_id = nil,

    power = 0,
    max_power = 0,

    -- depends on parent (d3ui_PlayerFrame)
    --height_offset = 160,
    height_offset =  -(CONSTS.SIZES.POWER_BAR.H * .5),
    ooc_height_offset = - (CONSTS.SIZES.POWER_BAR.H * .5),
}


function IPowerDisplay:CreateFrame ()
    CreateFrame("StatusBar", 'd3ui_PowerDisplay', d3ui_PlayerFrame, BackdropTemplateMixin and "BackdropTemplate")

    d3ui_PowerDisplay:SetSize(CONSTS.SIZES.POWER_BAR.W, CONSTS.SIZES.POWER_BAR.H)

    d3ui_PowerDisplay:SetFrameStrata("HIGH")
    d3ui_PowerDisplay:SetFrameLevel(CONSTS.LAYERS.POWER_BAR)
    d3ui_PowerDisplay:SetPoint("BOTTOM",0, IPowerDisplay.ooc_height_offset)

    local texture = d3ui_PowerDisplay:CreateTexture(nil,"BACKGROUND")
    texture:SetTexture(CONSTS.TEXTURES.POWER_BAR, true)
    d3ui_PowerDisplay.texture = texture

    d3ui_PowerDisplay:SetBackdrop({ bgFile = CONSTS.TEXTURES.POWER_BACKDROP_STALE })
    d3ui_PowerDisplay:SetStatusBarTexture(texture)

    d3ui_PowerDisplay:Show()
end

function IPowerDisplay:UpdateValues()
    IPowerDisplay.power = UnitPower('player', IPowerDisplay.power_type_id)
    IPowerDisplay.max_power = UnitPowerMax('player', IPowerDisplay.power_type_id)

    d3ui_PowerDisplay:SetMinMaxValues(0, IPowerDisplay.max_power)
    d3ui_PowerDisplay:SetValue(IPowerDisplay.power)
end


function IPowerDisplay:AddEventHandlers ()
    local events = {}

    function events:UNIT_POWER_UPDATE(...)
        IPowerDisplay:UpdateValues()
    end

    function events:PLAYER_REGEN_DISABLED(...)
        d3ui_PowerDisplay:SetPoint("CENTER",0, IPowerDisplay.height_offset)
        d3ui_PowerDisplay:SetBackdrop({ bgFile = CONSTS.TEXTURES.POWER_BACKDROP })
    end

    function events:PLAYER_REGEN_ENABLED(...)
        d3ui_PowerDisplay:SetPoint("CENTER",0, IPowerDisplay.ooc_height_offset)
        d3ui_PowerDisplay:SetBackdrop({  bgFile = CONSTS.TEXTURES.POWER_BACKDROP_STALE })
    end

    function events:UNIT_DISPLAYPOWER(...)
        IPowerDisplay:Recolor()
    end

    UTIL:RegisterEvents(d3ui_PowerDisplay, events)
end


function IPowerDisplay:Recolor ()
    local power_type_id, power_type = UnitPowerType("player")

    if(power_type_id ~= IPowerDisplay.power_type_id) then
        IPowerDisplay.power_type_id = power_type_id

        local colorConfig = CONSTS.COLORS.RESOURCES[power_type]
        if(colorConfig.gradient)  then
            d3ui_PowerDisplay.texture:SetTexture(CONSTS.TEXTURES.POWER_BAR_GRADIENT, true)
        else
            d3ui_PowerDisplay.texture:SetTexture(CONSTS.TEXTURES.POWER_BAR, true)
        end

        d3ui_PowerDisplay:SetStatusBarColor(colorConfig.r, colorConfig.g, colorConfig.b, 1)

        -- Recolor fires when primary resource changes (e.g druid switches forms.
        -- UpdateValues call ensures new min/current/max values are set properly)
        IPowerDisplay:UpdateValues()
    end
end

function IPowerDisplay:Load ()
    IPowerDisplay:CreateFrame()
    IPowerDisplay:AddEventHandlers()

    IPowerDisplay:Recolor() -- handles UpdateValues call
end

d3ui.PowerDisplay = IPowerDisplay