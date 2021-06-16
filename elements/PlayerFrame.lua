


IPlayerFrame = {
    hp = 0,
    max_hp = 0,
    absorb = 10,
}

function IPlayerFrame:UpdateValues()
    IPlayerFrame.hp = UnitHealth('player')
    IPlayerFrame.max_hp = UnitHealthMax('player')

    IPlayerFrame:UpdateHealPredictionValues()
    IPlayerFrame:UpdateAbsorbValues()

    d3ui_PlayerFrame_Health:SetMinMaxValues(0, IPlayerFrame.max_hp)
    d3ui_PlayerFrame_Health:SetValue(IPlayerFrame.hp)
end

function IPlayerFrame:UpdateAbsorbValues()
    local W, H = self.frame:GetSize()
    local absorb = UnitGetTotalAbsorbs('player')
    local absorbDelta =  math.max((self.hp + absorb) - self.max_hp, 0)

    if(absorb > 0) then
        self.absorbFrame:Show()

        local absorbPercent = absorb / self.max_hp
        local healthPercent = self.hp / self.max_hp

        self.absorbFrame:SetWidth(W * absorbPercent)

        self.absorbFrame.texture:SetTexCoord(1 - absorbPercent, math.min(healthPercent + absorbPercent, 1), 0, 1)

        if(absorbDelta > 0) then
            self.absorbFrame:ClearAllPoints()
            self.absorbFrame:SetPoint('RIGHT', 0, 0)
        else
            self.absorbFrame:ClearAllPoints()
            self.absorbFrame:SetPoint('LEFT', W * healthPercent, 0)
        end

        self.absorbFrame:Show()
    else
        self.absorbFrame:Hide()
    end
end

function IPlayerFrame:UpdateHealPredictionValues()
    local W, H = d3ui_PlayerFrame_Absorb:GetSize()
    local ownHealPredict = UnitGetIncomingHeals("player") or 0--, "player")
    local wastedHeal = math.max((IPlayerFrame.hp + ownHealPredict) - IPlayerFrame.max_hp, 0)

    ownHealPredict = ownHealPredict - wastedHeal

    if(wastedHeal > 0) then
    d3ui_PlayerFrame_Overheal:Show()
    else
    d3ui_PlayerFrame_Overheal:Hide()
    end

    if(ownHealPredict > 0) then
        d3ui_PlayerFrame_OwnHealPredict:Show()

        local ownHealPredictPercent = ownHealPredict / IPlayerFrame.max_hp
        local healthPercent = IPlayerFrame.hp / IPlayerFrame.max_hp

        d3ui_PlayerFrame_OwnHealPredict:SetWidth(W * ownHealPredictPercent)
        d3ui_PlayerFrame_OwnHealPredict.texture:SetTexCoord(1 - ownHealPredictPercent, healthPercent + ownHealPredictPercent, 0, 1)

        d3ui_PlayerFrame_OwnHealPredict:SetPoint('LEFT', W * healthPercent, 0 )
    else
        d3ui_PlayerFrame_OwnHealPredict:Hide()
    end
end

function IPlayerFrame:UpdateThreatValues()
    local threatConst = UnitThreatSituation('player')
    if(threatConst) then
        local colorConfig = CONSTS.COLORS.THREAT[threatConst]
         d3ui_PlayerFrame_Threat.texture:SetVertexColor(colorConfig.r, colorConfig.g, colorConfig.b, colorConfig.a)
         d3ui_PlayerFrame_Threat:Show()
    else
        d3ui_PlayerFrame_Threat:Hide()
    end

end

function IPlayerFrame:CreateOuterFrame ()
    CreateFrame("Button", 'd3ui_PlayerFrame', d3ui_Superframe, "SecureUnitButtonTemplate")
    -- position
    d3ui_PlayerFrame:SetSize(CONSTS.SIZES.PLAYER_FRAME.W, CONSTS.SIZES.PLAYER_FRAME.H)
    d3ui_PlayerFrame:SetFrameStrata("HIGH")
    d3ui_PlayerFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME)
    d3ui_PlayerFrame:SetPoint("CENTER", 0, CONSTS.COORDS.HEALTH_FRAME_Y)

    -- handle clicks
    d3ui_PlayerFrame:SetAttribute("unit", "player")
    d3ui_PlayerFrame:SetAttribute("type1", "target")
    d3ui_PlayerFrame:SetAttribute("type2", "togglemenu")
    d3ui_PlayerFrame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

    d3ui_PlayerFrame:Show()
end


function IPlayerFrame:CreateFrame ()
    self.frame = CreateFrame("StatusBar", "d3ui_PlayerFrame_Health", d3ui_PlayerFrame, BackdropTemplateMixin and "BackdropTemplate")

    d3ui_PlayerFrame_Health:SetSize(CONSTS.SIZES.PLAYER_FRAME.W, CONSTS.SIZES.PLAYER_FRAME.H)
    d3ui_PlayerFrame_Health:SetFrameStrata("HIGH")
    d3ui_PlayerFrame_Health:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP)
    d3ui_PlayerFrame_Health:SetPoint("CENTER", 0, 0)


    local texture = d3ui_PlayerFrame_Health:CreateTexture(nil,"BACKGROUND")
    texture:SetTexture(CONSTS.TEXTURES.HP_BAR)

    d3ui_PlayerFrame_Health:SetBackdrop({ bgFile = CONSTS.TEXTURES.HP_BACKDROP })
    d3ui_PlayerFrame_Health:SetStatusBarTexture(texture)
    d3ui_PlayerFrame_Health:SetStatusBarColor(CONSTS.COLORS.PLAYER_FRAME.r, CONSTS.COLORS.PLAYER_FRAME.g, CONSTS.COLORS.PLAYER_FRAME.b, 1)


    CreateFrame("Frame", "d3ui_PlayerFrame_Threat", d3ui_PlayerFrame)
    local pw,ph = d3ui_PlayerFrame:GetSize()
    d3ui_PlayerFrame_Threat:SetSize(pw*2, ph*2)
    d3ui_PlayerFrame_Threat:SetPoint("CENTER", 0, 0)
    d3ui_PlayerFrame_Threat:SetFrameStrata("HIGH")
    d3ui_PlayerFrame_Threat:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP - 1)
    threatTexture = d3ui_PlayerFrame_Threat:CreateTexture(nil, "ARTWORK")
    threatTexture:SetAllPoints(d3ui_PlayerFrame_Threat)
    threatTexture:SetTexture(CONSTS.TEXTURES.THREAT_BG)
    d3ui_PlayerFrame_Threat.texture = threatTexture
    d3ui_PlayerFrame_Threat:Hide()
end

function IPlayerFrame:CreateAbsorbBar()
    self.absorbFrame = CreateFrame("Frame", "d3ui_PlayerFrame_Absorb", d3ui_PlayerFrame, BackdropTemplateMixin and "BackdropTemplate")

    d3ui_PlayerFrame_Absorb:SetSize(CONSTS.SIZES.PLAYER_FRAME.W, CONSTS.SIZES.PLAYER_FRAME.H)
    d3ui_PlayerFrame_Absorb:SetFrameStrata("HIGH")
    d3ui_PlayerFrame_Absorb:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_ABSORB)
    d3ui_PlayerFrame_Absorb:SetPoint("LEFT", 0, 0)
    d3ui_PlayerFrame_Absorb:Show()

    local texture = d3ui_PlayerFrame_Absorb:CreateTexture(nil,"BACKGROUND")
    texture:SetTexture(CONSTS.TEXTURES.ABSORB)
    texture:SetVertexColor(CONSTS.COLORS.BASE.r, CONSTS.COLORS.BASE.g, CONSTS.COLORS.BASE.b, 1)
    texture:SetAllPoints(d3ui_PlayerFrame_Absorb)
    self.absorbFrame.texture = texture

    CreateFrame("Frame", "d3ui_PlayerFrame_OwnHealPredict", d3ui_PlayerFrame)
    --CreateFrame("Frame", "d3ui_PlayerFrame_HealPredict", d3ui_PlayerFrame)
    d3ui_PlayerFrame_OwnHealPredict:SetSize(CONSTS.SIZES.PLAYER_FRAME.W, CONSTS.SIZES.PLAYER_FRAME.H)
    d3ui_PlayerFrame_OwnHealPredict:SetPoint('LEFT', 0,0)
    d3ui_PlayerFrame_OwnHealPredict:SetPoint('BOTTOM')
    d3ui_PlayerFrame_OwnHealPredict:SetFrameStrata("HIGH")
    d3ui_PlayerFrame_OwnHealPredict:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_ABSORB)

    local ownHealPredictTexture = d3ui_PlayerFrame_OwnHealPredict:CreateTexture(nil,"BACKGROUND")
    ownHealPredictTexture:SetTexture(CONSTS.TEXTURES.HP_BAR)
    ownHealPredictTexture:SetAllPoints(d3ui_PlayerFrame_OwnHealPredict)
    ownHealPredictTexture:SetVertexColor(CONSTS.COLORS.PLAYER_FRAME_PREDICT.r, CONSTS.COLORS.PLAYER_FRAME_PREDICT.g, CONSTS.COLORS.PLAYER_FRAME_PREDICT.b, 1)
    d3ui_PlayerFrame_OwnHealPredict.texture = ownHealPredictTexture
    d3ui_PlayerFrame_OwnHealPredict:Show()

    CreateFrame("Frame", "d3ui_PlayerFrame_Overheal", d3ui_PlayerFrame)
    d3ui_PlayerFrame_Overheal:SetSize(8, 16)
    d3ui_PlayerFrame_Overheal:SetPoint('RIGHT', 8, 0)
    d3ui_PlayerFrame_Overheal:SetFrameStrata("HIGH")
    d3ui_PlayerFrame_Overheal:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_ABSORB - 1)

    local overhealTexture = d3ui_PlayerFrame_Overheal:CreateTexture(nil,"BACKGROUND")
    overhealTexture:SetTexture(CONSTS.TEXTURES.CHEVRON_RIGHT_W)
    overhealTexture:SetAllPoints(d3ui_PlayerFrame_Overheal)
    overhealTexture:SetVertexColor(CONSTS.COLORS.PLAYER_FRAME.r, CONSTS.COLORS.PLAYER_FRAME.g, CONSTS.COLORS.PLAYER_FRAME.b, 1)
    d3ui_PlayerFrame_Overheal:Hide()


end


function IPlayerFrame:AddEventHandlers ()
    local events = {}

    function events:UNIT_HEALTH(...)
        IPlayerFrame:UpdateValues()

        if(IPlayerFrame.hp/IPlayerFrame.max_hp <= 0.2) then
            d3ui_PlayerFrame_Health:SetStatusBarColor(CONSTS.COLORS.PLAYER_FRAME_DANGER.r, CONSTS.COLORS.PLAYER_FRAME_DANGER.g, CONSTS.COLORS.PLAYER_FRAME_DANGER.b, 1)
        else
            d3ui_PlayerFrame_Health:SetStatusBarColor(CONSTS.COLORS.PLAYER_FRAME.r, CONSTS.COLORS.PLAYER_FRAME.g, CONSTS.COLORS.PLAYER_FRAME.b, 1)
        end
    end

    function events:UNIT_ABSORB_AMOUNT_CHANGED(...)
        IPlayerFrame:UpdateAbsorbValues()
    end

    function events:UNIT_HEAL_PREDICTION(...)
        IPlayerFrame:UpdateHealPredictionValues()
    end

    function events:UNIT_THREAT_SITUATION_UPDATE(...)
        IPlayerFrame:UpdateThreatValues()
    end

    UTIL:RegisterEvents(d3ui_PlayerFrame_Health, {}, events)
end


function IPlayerFrame:Load ()
    IPlayerFrame:CreateOuterFrame()
    IPlayerFrame:CreateFrame()
    IPlayerFrame:CreateAbsorbBar()
    IPlayerFrame:AddEventHandlers()

    IPlayerFrame:UpdateValues()
    IPlayerFrame:UpdateAbsorbValues()
    IPlayerFrame:UpdateHealPredictionValues()
    IPlayerFrame:UpdateThreatValues()
end

d3ui.PlayerFrame = IPlayerFrame