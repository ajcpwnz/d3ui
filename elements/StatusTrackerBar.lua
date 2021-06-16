local BAR_HEIGHT = 5
local BAR_WIDTH = 460

IStatusTrackerBar = {
    current = 0,
    max = 0,
}


function OnEnter()
    local current, max = UnitXP('player'), UnitXPMax('player')
    IStatusTrackerBar.current = current
    d3ui_StatusTrackerBar_Exp:SetMinMaxValues(0, max)
    d3ui_StatusTrackerBar_Exp:SetValue(current)
    d3ui_StatusTrackerBar_Exp:Show()

    GameTooltip:SetOwner(d3ui_StatusTrackerBar, "ANCHOR_BOTTOMLEFT")
    GameTooltip:SetText(string.format("Level %s - %s: %s/%s (%d%% done)", UnitLevel('player'), UnitLevel('player') + 1, UTIL:FormatNumber(current), UTIL:FormatNumber(max), UTIL:Round((max > 0 and current / max or 0) * 100)))

    d3ui_StatusTrackerBar:SetAlpha(1)
end

function OnLeave()
    d3ui_StatusTrackerBar:SetAlpha(.7)
    GameTooltip:Hide()
end

function OnEnterRep()
    local name, standing, min, max, value = GetWatchedFactionInfo()
    if(not name) then return end;
    d3ui_StatusTrackerBar_Rep:SetMinMaxValues(min, max)
    d3ui_StatusTrackerBar_Rep:SetValue(value)

    GameTooltip:SetOwner(d3ui_StatusTrackerBar, "ANCHOR_BOTTOMLEFT")
    GameTooltip:SetText(name..' - '..(value - min)..'/'..(max - min)..' ('.. GetText("FACTION_STANDING_LABEL"..standing) ..')')

    d3ui_StatusTrackerBar:SetAlpha(1)
end

function OnLeaveRep()
    d3ui_StatusTrackerBar:SetAlpha(.7)
    GameTooltip:Hide()
end

function IStatusTrackerBar:Update()
    self.hasExp = true

    if (UnitLevel('player') >= CONSTS.MAX_LVL) then
        self.expBar:Hide()
        self.hasExp = false
    end

    if (self.hasExp) then
        local current, max = UnitXP('player'), UnitXPMax('player')
        local restedExp = GetXPExhaustion()

        if (restedExp) then
            d3ui_StatusTrackerBar_Exp:SetStatusBarColor(55 / 255, 51 / 255, 216 / 255, 1)
            d3ui_StatusTrackerBar_Rested:SetMinMaxValues(0, max)
            d3ui_StatusTrackerBar_Rested:SetValue(math.min(current + restedExp, max))
        else
            d3ui_StatusTrackerBar_Rested:Hide()
        end

        IStatusTrackerBar.current = current

        d3ui_StatusTrackerBar_Exp:SetMinMaxValues(0, max)
        d3ui_StatusTrackerBar_Exp:SetValue(current)
        d3ui_StatusTrackerBar_Exp:Show();
    end

    local hasRep = false
    local name, standing, min, max, value = GetWatchedFactionInfo()
    if (name) then
        hasRep = true
        self.repBar:SetMinMaxValues(min, max)
        self.repBar:SetValue(value)
        self.repBar:Show()
    end

    if (hasRep and self.hasExp) then
        self.frame:ClearAllPoints()
        self.frame:SetPoint("BOTTOMLEFT", 0,  -1)
    else
        if (hasRep or  self.hasExp) then
            self.frame:ClearAllPoints()
            self.frame:SetPoint("BOTTOMLEFT", 0,-BAR_HEIGHT - 1)
        else
            self.frame:SetAlpha(0)
        end
    end
end


function IStatusTrackerBar:CreateFrame()
    local frame = CreateFrame("Frame", 'd3ui_StatusTrackerBar', UIParent, BackdropTemplateMixin and "BackdropTemplate")


    d3ui_StatusTrackerBar:SetAlpha(.7)

    d3ui_StatusTrackerBar:SetFrameStrata("HIGH")
    d3ui_StatusTrackerBar:SetSize(BAR_WIDTH, BAR_HEIGHT * 2)
    d3ui_StatusTrackerBar:SetPoint("BOTTOMLEFT", 0, -1)

    d3ui_StatusTrackerBar:SetBackdropBorderColor(0, 0, 0, 1)

    d3ui_StatusTrackerBar:Show()
    self.frame = frame
end

function IStatusTrackerBar:CreateExpBar()
    local expBar = CreateFrame("StatusBar", 'd3ui_StatusTrackerBar_Exp', d3ui_StatusTrackerBar, BackdropTemplateMixin and "BackdropTemplate")
    d3ui_StatusTrackerBar_Exp:SetSize(BAR_WIDTH, BAR_HEIGHT)
    d3ui_StatusTrackerBar_Exp:SetPoint("TOP", 0, 0)
    d3ui_StatusTrackerBar_Exp:SetFrameLevel(0)

    expBar:SetScript("OnEnter", OnEnter)
    expBar:SetScript("OnLeave", OnLeave)
    expBar:EnableMouse(true)

    local texture = d3ui_StatusTrackerBar_Exp:CreateTexture(nil, "BACKGROUND")

    texture:SetTexture(CONSTS.TEXTURES.BAR_PLAIN, true)
    d3ui_StatusTrackerBar_Exp:SetStatusBarTexture(texture)
    d3ui_StatusTrackerBar_Exp:SetBackdrop({
        bgFile = CONSTS.TEXTURES.BAR_PLAIN,
    })
    d3ui_StatusTrackerBar_Exp:SetBackdropColor(0, 0, 0, 1)

    d3ui_StatusTrackerBar_Exp:SetStatusBarColor(203 / 255, 9 / 255, 235 / 255, .5)
    d3ui_StatusTrackerBar_Exp:Show()


    CreateFrame("StatusBar", 'd3ui_StatusTrackerBar_Rested', d3ui_StatusTrackerBar, BackdropTemplateMixin and "BackdropTemplate")
    d3ui_StatusTrackerBar_Rested:SetSize(BAR_WIDTH, BAR_HEIGHT)
    d3ui_StatusTrackerBar_Rested:SetPoint("BOTTOM", 0, 0)
    d3ui_StatusTrackerBar_Rested:SetFrameLevel(0)

    local texture = d3ui_StatusTrackerBar_Rested:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture(CONSTS.TEXTURES.BAR_PLAIN, true)
    d3ui_StatusTrackerBar_Rested:SetStatusBarTexture(texture)

    d3ui_StatusTrackerBar_Rested:SetStatusBarColor(95 / 255, 255 / 255, 255 / 255, .75)
    d3ui_StatusTrackerBar_Rested:Show()

    self.expBar = expBar
end

function IStatusTrackerBar:CreateRepBar()
    local repBar = CreateFrame("StatusBar", 'd3ui_StatusTrackerBar_Rep', d3ui_StatusTrackerBar, BackdropTemplateMixin and "BackdropTemplate")
    repBar:SetSize(BAR_WIDTH, BAR_HEIGHT)
    if(self.hasExp) then
        repBar:SetPoint("BOTTOM", 0, 0)
    else
        repBar:SetPoint("TOP", 0, 0)
    end
    repBar:SetFrameLevel(0)

    repBar:SetScript("OnEnter", OnEnterRep)
    repBar:SetScript("OnLeave", OnLeaveRep)
    repBar:EnableMouse(true)

    local texture = repBar:CreateTexture(nil, "BACKGROUND")

    texture:SetTexture(CONSTS.TEXTURES.BAR_PLAIN, true)

    repBar:SetStatusBarTexture(texture)
    repBar:SetBackdrop({
        bgFile = CONSTS.TEXTURES.BAR_PLAIN,
    })
    repBar:SetBackdropColor(0, 0, 0, 1)

    repBar:SetStatusBarColor(203 / 255, 9 / 255, 235 / 255, .5)
    repBar:Show()
    self.repBar = repBar
end


function IStatusTrackerBar:AddEventHandlers()
    local events = {}
    function events:PLAYER_XP_UPDATE() IStatusTrackerBar:Update() end

    function events:UPDATE_EXHAUSTION() IStatusTrackerBar:Update() end

    function events:PLAYER_LEVEL_UP() IStatusTrackerBar:Update() end

    function events:UPDATE_FACTION() IStatusTrackerBar:Update() end

    UTIL:RegisterEvents(d3ui_StatusTrackerBar, events)
end

function IStatusTrackerBar:Load()
    IStatusTrackerBar:CreateFrame()
    IStatusTrackerBar:CreateExpBar()
    IStatusTrackerBar:CreateRepBar()
    IStatusTrackerBar:AddEventHandlers()

    IStatusTrackerBar:Update()
end

d3ui.StatusTrackerBar = IStatusTrackerBar
