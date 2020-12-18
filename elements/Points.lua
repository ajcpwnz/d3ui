local PowerPointsMap = {
    [2] = 9,
    [4] = 4,
    [9] = 7,
    [10] = 12,
    [6] = 5,
}
local PowerToTokens = {
    [9] = "HOLY_POWER",
    [4] = "COMBO_POINTS",
    [7] = "SOUL_SHARDS",
    [12] = "CHI",
    [6] = "RUNE",
}

IPointsDisplay = {
    powerId = nil,
    powerType = nil,

    frame = {},

    curr_combopoints = 0,
    max_combopoints = 0,
    --height_offset = 170,
    height_offset = 0,
    ooc_height_offset = 0,
    in_combat = false
}


function IPointsDisplay:CreateFrame ()
    local frame = CreateFrame("Frame", 'd3ui_PointsDisplay',  d3ui_PlayerFrame)

    d3ui_PointsDisplay:SetSize(1,1)
    d3ui_PointsDisplay:SetFrameStrata("HIGH")
    d3ui_PointsDisplay:SetFrameLevel(CONSTS.LAYERS.POINTS_POWER_BAR)
    d3ui_PointsDisplay:SetPoint("TOP", 0, 0)

    d3ui_PointsDisplay:Show()
end

function IPointsDisplay:CreatePoints()
    d3ui_PointsDisplay.points = {}

    local pointWidth = ((CONSTS.SIZES.PLAYER_FRAME.W  - 40) / IPointsDisplay.max_combopoints)
    local pointInnerWidth = pointWidth - 4

    local startingPointOffset = 0 - (((IPointsDisplay.max_combopoints + 1) * pointWidth) * 0.5)

    local colorConfig = CONSTS.COLORS.RESOURCES[IPointsDisplay.powerType]

    for i = 1, IPointsDisplay.max_combopoints do
        local pointFrame = CreateFrame("StatusBar", nil, d3ui_PointsDisplay, BackdropTemplateMixin and "BackdropTemplate")
        pointFrame:SetSize(pointInnerWidth, pointInnerWidth * 0.5)
        pointFrame:SetFrameStrata("HIGH")
        pointFrame:SetPoint("CENTER", startingPointOffset + (pointWidth * i), 0)

        pointFrame:SetMinMaxValues(0, 1)

        local texture = pointFrame:CreateTexture(nil,"BACKGROUND")
        texture:SetVertexColor(colorConfig.r, colorConfig.g, colorConfig.b, 1)
        texture:SetTexture(CONSTS.TEXTURES.COMBO)
        texture:SetAllPoints(pointFrame)
        pointFrame.texture = texture

        pointFrame:SetBackdrop({ bgFile = CONSTS.TEXTURES.COMBO_STALE })
        pointFrame:SetStatusBarTexture(texture)

        if(IPointsDisplay.specialMode) then
            pointFrame:Hide()
        else
            pointFrame:Show()
        end

        d3ui_PointsDisplay.points[i] = pointFrame
    end
end

function IPointsDisplay:UpdateValues ()
    IPointsDisplay.curr_combopoints = UnitPower('player', IPointsDisplay.powerId, true)
    if(IPointsDisplay.powerType == 'SOUL_SHARDS') then
     IPointsDisplay.curr_combopoints =  IPointsDisplay.curr_combopoints / 10
    end

    for i = 1, IPointsDisplay.max_combopoints do
        filled = i <= math.ceil(IPointsDisplay.curr_combopoints)
        v = 1
        if(((i - 1) < IPointsDisplay.curr_combopoints) and ((i) > IPointsDisplay.curr_combopoints)) then
            v = IPointsDisplay.curr_combopoints - (i - 1)
        end
        if(filled) then
            d3ui_PointsDisplay.points[i]:SetValue(v)
        else
            d3ui_PointsDisplay.points[i]:SetValue(0)
            -- d3ui_PointsDisplay.points[i].texture:SetVertexColor(CONSTS.COLORS.BASE.r, CONSTS.COLORS.BASE.g, CONSTS.COLORS.BASE.b, 1)
        end
    end
end

function IPointsDisplay:UpdateSingleRune(i, filled, start, duration, index)
    --local start, duration, filled = GetRuneCooldown(i)
    local colorConfig = CONSTS.COLORS.RESOURCES[IPointsDisplay.powerType]
    local rechargingColorConfig = CONSTS.COLORS.RESOURCES.RUNE_RECHARGING
    d3ui_PointsDisplay.points[i]:Show()
    d3ui_PointsDisplay.points[i].index = index

    if(filled) then
        d3ui_PointsDisplay.points[i]:SetMinMaxValues(0, 1)
        d3ui_PointsDisplay.points[i]:SetValue(1)
        d3ui_PointsDisplay.points[i].texture:SetVertexColor(colorConfig.r, colorConfig.g, colorConfig.b, 1)
    else
        d3ui_PointsDisplay.points[i]:SetMinMaxValues(start or 0, (start  or 0) + (duration or 0))
        d3ui_PointsDisplay.points[i]:SetValue(GetTime())
        d3ui_PointsDisplay.points[i].texture:SetVertexColor(rechargingColorConfig.r, rechargingColorConfig.g, rechargingColorConfig.b, 1)
        -- d3ui_PointsDisplay.points[i].texture:SetVertexColor(CONSTS.COLORS.BASE.r, CONSTS.COLORS.BASE.g, CONSTS.COLORS.BASE.b, 1)
    end
end

function IPointsDisplay:UpdateRunes ()
    local pointIterator = {}
    local filledCount = 0

    for i = 1, IPointsDisplay.max_combopoints do
        local start, duration, filled = GetRuneCooldown(i)
        if(filled) then fileldCount = filledCount + 1 end
        pointIterator[i] = {index = i, filled = filled, start = start, duration = duration }
    end

    self.filledRunes = filledCount

    for i = 1, IPointsDisplay.max_combopoints do
        for j = 1, (IPointsDisplay.max_combopoints - i) do
            if(not pointIterator[j].filled) then
                if(pointIterator[j].start > pointIterator[j + 1].start) then
                    local temp = pointIterator[j]
                    pointIterator[j] = pointIterator[j + 1]
                    pointIterator[j + 1] = temp
                end
            end
        end
    end

    for k,v in pairs(pointIterator) do
        IPointsDisplay:UpdateSingleRune(k, v.filled, v.start, v.duration, v.index)
    end
end



function IPointsDisplay:UpdateValuesAndReposition ()
    local colorConfig = CONSTS.COLORS.RESOURCES[IPointsDisplay.powerType]
    local pointWidth = ((CONSTS.SIZES.PLAYER_FRAME.W  - 10) / IPointsDisplay.max_combopoints)
    local pointInnerWidth = pointWidth - 4
    local startingPointOffset = 0 - (((IPointsDisplay.curr_combopoints + 1) * pointWidth) * 0.5)
    local j = 0

    for i = 1, (IPointsDisplay.max_combopoints) do
        filled = (i <= IPointsDisplay.curr_combopoints)
        if(filled)then
            j = j + 1
            d3ui_PointsDisplay.points[i].texture:SetVertexColor(colorConfig.r, colorConfig.g, colorConfig.b, 1)
            d3ui_PointsDisplay.points[i].texture:SetTexture(CONSTS.TEXTURES.COMBO)
            d3ui_PointsDisplay.points[i]:SetPoint("CENTER", startingPointOffset + (pointWidth * j), 0)
            d3ui_PointsDisplay.points[i]:Show()
        else
            d3ui_PointsDisplay.points[i]:Hide()
        end
    end
end

function IPointsDisplay:AddEventHandlers ()
    local events = {}
    local unitEvents = {}

    function events:UNIT_POWER_UPDATE(...)
        if(not IPointsDisplay.specialMode) then
            IPointsDisplay:UpdateValues()
        end
    end

    function events:PLAYER_REGEN_DISABLED(...)
       IPointsDisplay.in_combat = true
       d3ui_PointsDisplay:SetPoint("CENTER",0,   IPointsDisplay.height_offset)
        if(not IPointsDisplay.specialMode) then
           IPointsDisplay:UpdateValues()
        end
    end

    function events:PLAYER_REGEN_ENABLED(...)
        IPointsDisplay.in_combat = false
        d3ui_PointsDisplay:SetPoint("CENTER",0, IPointsDisplay.ooc_height_offset)
        if(not IPointsDisplay.specialMode) then
           IPointsDisplay:UpdateValues()
        end
    end

    if(IPointsDisplay.specialMode == 'ICICLES') then
        function unitEvents:UNIT_AURA(...)
            -- TODO: Fix aura lookup.
            local ic = nil
            for idx = 1,40 do
                local name, _, count = UnitAura("player", idx, 'HELPFUL')
                if(name == 'Icicles') then
                    ic = count
                    break
                end
            end

            IPointsDisplay.curr_combopoints = ic or 0
            IPointsDisplay:UpdateValuesAndReposition()
        end
    end

    if(IPointsDisplay.specialMode == 'RUNE') then
        function events:RUNE_POWER_UPDATE (...)
            IPointsDisplay:UpdateRunes()
        end

        for i = 1,IPointsDisplay.max_combopoints do
            d3ui_PointsDisplay.points[i]:HookScript("OnUpdate", THROTTLER:Hook('update_runes', function()
                if(d3ui_PointsDisplay.filledRunes == 6) then return end;

                local point = d3ui_PointsDisplay.points[i]
                local start, duration, filled = GetRuneCooldown(point.index)
                if(not filled) then
                    local rechargingColorConfig = CONSTS.COLORS.RESOURCES.RUNE_RECHARGING
                    point:SetMinMaxValues(start or 0, (start  or 0) + (duration or 0))
                    point:SetValue(GetTime())
                    point.texture:SetVertexColor(rechargingColorConfig.r, rechargingColorConfig.g, rechargingColorConfig.b, 1)
                end
            end))
        end
    end

    UTIL:RegisterEvents(d3ui_PointsDisplay, events, unitEvents)
end

function CheckIfHasBalls()
   local className, classFilename, classId = UnitClass('player')
   if((classId == 2) or (classId == 4) or (classId == 9) or (classId == 10)) then
    return classId
   else
    if(classId == 6) then
        return 8, 'RUNE'
    end

    if(classId == 8) then
        spec = GetSpecialization()
        if(spec == 3) then return 8, 'ICICLES' end
    end
    return nil
   end
end

function IPointsDisplay:Load ()
    local classId, specialMode = CheckIfHasBalls()
    if(not classId) then return end

    IPointsDisplay.powerId = PowerPointsMap[classId]
    IPointsDisplay.powerType = specialMode or PowerToTokens[IPointsDisplay.powerId]
    IPointsDisplay.specialMode = specialMode

    if(IPointsDisplay.specialMode) then
        IPointsDisplay.curr_combopoints = 0
        if(IPointsDisplay.specialMode == 'RUNE') then
            IPointsDisplay.max_combopoints = 6
        else
            IPointsDisplay.max_combopoints = 5
        end
    else
        IPointsDisplay.curr_combopoints = UnitPower('player', IPointsDisplay.powerId)
        IPointsDisplay.max_combopoints = UnitPowerMax('player', IPointsDisplay.powerId)
    end

    IPointsDisplay:CreateFrame()
    IPointsDisplay:CreatePoints()
    IPointsDisplay:AddEventHandlers()
    IPointsDisplay:UpdateValues()

    if(IPointsDisplay.specialMode == 'RUNE') then
        IPointsDisplay:UpdateRunes()
    end
end

d3ui.PointsDisplay = IPointsDisplay