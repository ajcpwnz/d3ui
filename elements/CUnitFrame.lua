CUnitFrame = {
    name = '',
    hp = 0,
    max_hp = 0,
    isEnemy = nil,
    canAttack = nil
}

function CUnitFrame:ToggleVisibility()
    local name = UnitName(self.unit)
    if (name) then
        self.frame:Show()
    else
        self.frame:Hide()
    end

    return name
end

function CUnitFrame:UpdateColors(newName)
    local isEnemy = UnitIsEnemy(self.unit, "player")
    local canAttack = UnitCanAttack(self.unit, "player")

    if ((isEnemy == self.isEnemy) and (canAttack == self.canAttack) and (newName == self.name)) then return end;
    self.isEnemy = isEnemy
    self.canAttack = canAttack

    local className, classToken = UnitClass(self.unit)
    local colorConfig = CONSTS.COLORS.CLASSES[classToken] or CONSTS.COLORS.CLASSES.DEFAULT
    local reactionColor = CONSTS.COLORS.FRIENDLY
    if (isEnemy) then
        if (canAttack) then
            reactionColor = CONSTS.COLORS.ENEMY
        else
            reactionColor = CONSTS.COLORS.PROTECTED_ENEMY
        end
    end

    if (UnitIsPlayer(self.unit)) then
        if (self.config.SPECIALS.reaction) then
            self.classFrame:Show()
            self.classFrame.texture:SetVertexColor(reactionColor.r, reactionColor.g, reactionColor.b, 1)
        end
        self.frame:SetStatusBarColor(colorConfig.r, colorConfig.g, colorConfig.b, 1)
    else
        if (self.config.SPECIALS.reaction) then
            self.classFrame:Hide()
        end
        self.frame:SetStatusBarColor(reactionColor.r, reactionColor.g, reactionColor.b, 1)
    end
end

function CUnitFrame:HandleChange()
    local name = self:ToggleVisibility()
    if (not name) then return end
    self:UpdateHealth()

    if (self.config.SPECIALS.auras) then
        self.auraFrame:DisplayAuras()
    end

    self:UpdateColors(newName)

    self.name = name
    self.textNodes.nameText:SetText(self.name)

    local unitLevel = UnitLevel(self.unit)
    if (unitLevel == -1) then
        self.textNodes.levelText:SetText('')
        if (self.indicatorFrame) then
            self.indicatorFrame:SetBackdrop({ bgFile = CONSTS.TEXTURES.TARGET_INDICATOR_BOSS })
            self.indicatorFrame:SetBackdrop({ bgFile = CONSTS.TEXTURES.TARGET_INDICATOR_BOSS })
            self.indicatorFrame:SetPoint('RIGHT', 6, 0)
        end
    else
        self.textNodes.levelText:SetText(unitLevel)
        if (self.indicatorFrame) then
            self.indicatorFrame:SetPoint("RIGHT", 18, 0)
            self.indicatorFrame:SetBackdrop({ bgFile = CONSTS.TEXTURES.TARGET_INDICATOR })
        end
    end
    self:UpdateThreatValues()
end

function CUnitFrame:UpdateHealth()
    self:UpdateColors()
    self.hp = UnitHealth(self.unit)
    self.max_hp = UnitHealthMax(self.unit)

    self.frame:SetMinMaxValues(0, self.max_hp)
    self.frame:SetValue(math.max(self.hp, 0))

    self:UpdateAbsorb()
    self:UpdateHealPredictionValues()

    if (UnitIsDead(self.unit)) then
        self.textNodes.hpText:SetText('')
        self.textNodes.hpPercentText:SetText('Dead')
    else
        self.textNodes.hpText:SetText(UTIL:FormatHP(self.hp))
        self.textNodes.hpPercentText:SetText(math.floor((self.hp / self.max_hp) * 100 + 0.5) .. '%')
    end
end

function CUnitFrame:UpdateThreatValues()
    if (self.unit == 'targettarget') then return end;
    local threatConst = UnitThreatSituation('player', self.unit)
    if (threatConst) then
        local colorConfig = CONSTS.COLORS.THREAT[threatConst]
        self.threatFrame.texture:SetVertexColor(colorConfig.r, colorConfig.g, colorConfig.b, colorConfig.a)
        self.threatFrame:Show()
    else
        self.threatFrame:Hide()
    end
end

function CUnitFrame:UpdateAbsorb()
    local W, H = self.frame:GetSize()
    local absorb = UnitGetTotalAbsorbs(self.unit)
    local absorbDelta = math.max((self.hp + absorb) - self.max_hp, 0)

    if (absorb > 0) then
        self.absorbFrame:Show()

        local absorbPercent = absorb / self.max_hp
        local healthPercent = self.hp / self.max_hp

        self.absorbFrame:SetWidth(W * absorbPercent)

        self.absorbFrame.texture:SetTexCoord(1 - absorbPercent, math.min(healthPercent + absorbPercent, 1), 0, 1)

        if (absorbDelta > 0) then
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

function CUnitFrame:UpdateHealPredictionValues()
    local W, H = self.frame:GetSize()
    local ownHealPredict = UnitGetIncomingHeals(self.unit) or 0 --, "player")
    local wastedHeal = math.max((self.hp + ownHealPredict) - self.max_hp, 0)

    ownHealPredict = ownHealPredict - wastedHeal

    if (ownHealPredict > 0) then
        self.healPredictFrame:Show()

        local ownHealPredictPercent = ownHealPredict / self.max_hp
        local healthPercent = self.hp / self.max_hp

        self.healPredictFrame:SetWidth(W * ownHealPredictPercent)
        self.healPredictFrame.texture:SetTexCoord(1 - ownHealPredictPercent, healthPercent + ownHealPredictPercent, 0, 1)

        self.healPredictFrame:SetPoint('LEFT', W * healthPercent, 0)
        self.healPredictFrame:Show()
    else
        self.healPredictFrame:Hide()
    end
end

function CUnitFrame:UpdateRoleIcon()
    local role = UnitGroupRolesAssigned(self.unit);
    if ((role == "TANK" or role == "HEALER" or role == "DAMAGER")) then
        local config = CONSTS.ROLE_TEX_COORDS[role]
        self.roleIcon:SetTexture(CONSTS.TEXTURES.ROLES);
        self.roleIcon:SetTexCoord(config.l, config.r, config.t, config.b);
        self.roleIcon:Show();
    else
        self.roleIcon:Hide();
    end
end

function CUnitFrame:UpdateLoggedInStatus()
    if (not UnitIsConnected(self.unit)) then
        self.textNodes.hpPercentText:SetText('OFFLINE')
        self.frame:SetStatusBarColor(.7, .7, .7, 1)
    end
end

function CUnitFrame:CreateOuterFrame()
    self.outerFrame = CreateFrame("Button", 'd3ui_UnitFrame_' .. self.unit, self.parent, "SecureUnitButtonTemplate")
    self.outerFrame:SetSize(self.config.W, self.config.H)
    self.outerFrame:SetFrameStrata("HIGH")
    self.outerFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME)
    self.outerFrame:SetPoint(self.config.POINT or "CENTER", self.config.X, self.config.Y)
    self.outerFrame:Show()

    -- handle clicks
    self.outerFrame:SetAttribute("unit", self.unit)
    self.outerFrame:SetAttribute("type1", "target")
    self.outerFrame:SetAttribute("type2", "togglemenu")
    self.outerFrame:RegisterForClicks('LeftButtonUp', 'RightButtonUp')

    if (self.config.ROLE == 'party' or self.config.ROLE == 'raid' ) then
        self.outerFrame:SetScript("OnEnter", function()
             self.frame.texture:SetTexture(self.config.BAR_TEXTURE_HOVER)
            end)
        self.outerFrame:SetScript("OnLeave", function() 
            self.frame.texture:SetTexture(self.config.BAR_TEXTURE)
            self.textNodes.hpText:Hide()
            self.textNodes.nameText:Hide()
         end)
    end

    self.outerFrame:EnableMouse(true)

    self.textNodes = {}
end

function CUnitFrame:CreateHealthFrame()
    local inst = self
    self.frame = CreateFrame("StatusBar", "d3ui_UnitFrame_Health_" .. self.unit, self.outerFrame, BackdropTemplateMixin and "BackdropTemplate")

    self.frame:SetSize(self.config.W, self.config.H)
    self.frame:SetFrameStrata("HIGH")
    self.frame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP)
    self.frame:SetPoint("CENTER", 0, 0)



    local texture = self.frame:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture(self.config.BAR_TEXTURE)
    self.frame.texture = texture
    self.frame:SetBackdrop({ bgFile = self.config.BAR_BACKDROP })
    self.frame:SetStatusBarTexture(texture)

    --    if (self.config.ROLE == 'party') then
    --        self.frame:SetBackdrop({ bgFile = self.config.BAR_BACKDROP, edgeFile = "Interface\\AddOns\\d3ui\\inc\\border-light.blp", edgeSize = 4 })
    --    end

    self.frame:SetStatusBarColor(CONSTS.COLORS.PLAYER_FRAME.r, CONSTS.COLORS.PLAYER_FRAME.g, CONSTS.COLORS.PLAYER_FRAME.b, 1)

    if (self.config.SPECIALS.level) then
        self.indicatorFrame = CreateFrame("Frame", "d3ui_UnitFrame_Indicator_" .. self.unit, self.frame, BackdropTemplateMixin and "BackdropTemplate")
        self.indicatorFrame:SetSize(64 * .75, 24)
        self.indicatorFrame:SetFrameStrata("HIGH")
        self.indicatorFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP - 1)
        self.indicatorFrame:SetPoint("RIGHT", 18, 0)
        self.indicatorFrame:SetBackdrop({ bgFile = CONSTS.TEXTURES.TARGET_INDICATOR })
        self.indicatorFrame:Show()
    end

    if (self.config.SPECIALS.reaction) then
        self.classFrame = CreateFrame("Frame", "d3ui_UnitFrame_Class_" .. self.unit, self.frame, BackdropTemplateMixin and "BackdropTemplate")
        self.classFrame:SetSize(64 * .75, 24)
        self.classFrame:SetFrameStrata("HIGH")
        self.classFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP - 1)
        self.classFrame:SetPoint("LEFT", -6, 0)
        self.classFrame.texture = self.classFrame:CreateTexture(nil, "BACKGROUND")
        self.classFrame.texture:SetTexture(CONSTS.TEXTURES.CLASS_INDICATOR)
        self.classFrame.texture:SetAllPoints(self.classFrame)
        self.classFrame:Show()
    end

    self.absorbFrame = CreateFrame("Frame", "d3ui_UnitFrame_Absorb_" .. self.unit, self.frame)
    self.absorbFrame:SetSize(self.config.W, self.config.H)
    self.absorbFrame:SetPoint('LEFT', 0, 0)
    self.absorbFrame:SetPoint('BOTTOM')
    self.absorbFrame:SetFrameStrata("HIGH")
    self.absorbFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_ABSORB)

    local absorbTexture = self.absorbFrame:CreateTexture(nil, "BACKGROUND")
    absorbTexture:SetTexture(self.config.ABSORB_TEXTURE)
    absorbTexture:SetAllPoints(self.absorbFrame)
    self.absorbFrame.texture = absorbTexture

    self.healPredictFrame = CreateFrame("Frame", "d3ui_UnitFrame_OwnHealPredict_" .. self.unit, self.frame)
    self.healPredictFrame:SetSize(self.config.W, self.config.H)
    self.healPredictFrame:SetPoint('LEFT', 0, 0)
    self.healPredictFrame:SetPoint('BOTTOM')
    self.healPredictFrame:SetFrameStrata("HIGH")
    self.healPredictFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_ABSORB)

    local ownHealPredictTexture = self.healPredictFrame:CreateTexture(nil, "BACKGROUND")
    ownHealPredictTexture:SetTexture(self.config.BAR_TEXTURE)
    ownHealPredictTexture:SetAllPoints(self.healPredictFrame)
    ownHealPredictTexture:SetVertexColor(CONSTS.COLORS.PLAYER_FRAME_PREDICT.r, CONSTS.COLORS.PLAYER_FRAME_PREDICT.g, CONSTS.COLORS.PLAYER_FRAME_PREDICT.b, 1)
    self.healPredictFrame.texture = ownHealPredictTexture
    self.healPredictFrame:Show()

    self.textFrame = CreateFrame("Frame", "d3ui_UnitFrame_TextFrame_" .. self.unit, self.frame)
    self.textFrame:SetSize(self.config.W, self.config.H)
    self.textFrame:SetAllPoints(self.frame)
    self.textFrame:SetFrameStrata("HIGH")
    self.textFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_ABSORB + 2)

    local nameText = UTIL:AddText(self.textFrame)
    local levelText = UTIL:AddText(self.textFrame)
    local hpPercentText = UTIL:AddText(self.textFrame)
    local hpText = UTIL:AddText(self.textFrame)

    if (self.config.ROLE == 'party') then
        levelText:SetPoint("BOTTOMRIGHT", -2, -12)
        nameText:SetPoint("BOTTOMLEFT", 2, -12)
        hpPercentText:SetPoint("BOTTOMLEFT", 2, 2)
        hpPercentText:SetFont(CONSTS.FONTS.BASE, 14)
        hpText:SetPoint("BOTTOMLEFT", 2, 2)
        hpText:Hide()
        nameText:Hide()
        levelText:Hide()
    elseif (self.config.ROLE == 'raid') then
        levelText:Hide()
        nameText:SetPoint("TOPLEFT", 2, -2)
        hpPercentText:SetPoint("BOTTOMLEFT", 2, 2)
        hpPercentText:SetFont(CONSTS.FONTS.BASE, 14)
        hpText:SetPoint("BOTTOMLEFT", 2, 2)
        nameText:Hide()
        hpText:Hide()
    else
        if (self.config.ROLE == 'targettarget') then
            levelText:Hide()
            nameText:SetPoint("LEFT", 6, -18)
            hpPercentText:SetPoint("LEFT", 6, 0)
            hpPercentText:SetFont(CONSTS.FONTS.BASE, 10)
            hpText:SetPoint("RIGHT", -6, 0)
        else
            levelText:SetPoint("RIGHT", 13, 0)
            nameText:SetPoint("LEFT", 6, 18)
            hpPercentText:SetPoint("LEFT", 6, 0)
            hpPercentText:SetFont(CONSTS.FONTS.BASE, 10)
            hpText:SetPoint("RIGHT", -6, 0)
        end
    end

    if(self.config.SPECIALS.essential_aura) then
        self.essentials = d3ui.EssentialAura:Load(self.unit, self.outerFrame)
    end

    self.textNodes.nameText = nameText
    self.textNodes.levelText = levelText
    self.textNodes.hpPercentText = hpPercentText

    self.textNodes.hpText = hpText

    self.threatFrame = CreateFrame("Frame", "d3ui_UnitFrame_Threat_" .. self.unit, self.frame)
    local pw, ph = self.frame:GetSize()
    self.threatFrame:SetSize(pw * 2, ph * 2)
    self.threatFrame:SetPoint("CENTER", 0, 0)
    self.threatFrame:SetFrameStrata("HIGH")
    self.threatFrame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP - 1)
    threatTexture = self.threatFrame:CreateTexture(nil, "ARTWORK")
    threatTexture:SetAllPoints(self.threatFrame)
    threatTexture:SetTexture(CONSTS.TEXTURES.THREAT_BG)
    self.threatFrame.texture = threatTexture
    self.threatFrame:Hide()


    if (self.config.ROLE == 'party' or self.config.ROLE == 'raid' ) then
        self.roleIcon = self.frame:CreateTexture(nil, "OVERLAY")
        self.roleIcon:SetPoint('BOTTOMRIGHT', -2, 2)
        self.roleIcon:SetSize(16, 16)
    end

    self.frame:Show()
end


function CUnitFrame:AddEventHandlers()
    local inst = self
    local events = {}
    local unitEvents = {}

    if (inst.unit == 'target' or inst.unit == 'targettarget') then
        function events:PLAYER_TARGET_CHANGED()
            inst:HandleChange()
        end

        function events:UNIT_THREAT_SITUATION_UPDATE(...)
            local unit = ...;
            if (unit ~= 'player') then return end
            inst:UpdateThreatValues()
        end
    end

    if (inst.unit == 'focus') then
        function events:PLAYER_FOCUS_CHANGED()
            inst:HandleChange()
        end
    end

    function events:UNIT_HEAL_PREDICTION(...)
        inst:UpdateHealPredictionValues()
    end

    function unitEvents:UNIT_HEALTH(...)
        inst:UpdateHealth()
    end

    function unitEvents:UNIT_ABSORB_AMOUNT_CHANGED(...)
        inst:UpdateAbsorb()
    end

    if (inst.config.ROLE == 'party' or inst.config.ROLE == 'raid') then
        function events:PLAYER_ROLES_ASSIGNED()
            inst:UpdateRoleIcon()
        end

        function events:PLAYER_FLAGS_CHANGED()
            inst:UpdateLoggedInStatus()
        end
    end

    UTIL:RegisterEvents(inst.frame, events, unitEvents, inst.unit)


    if (inst.config.ROLE == 'party' or inst.config.ROLE == 'raid') then
        inst.frame:HookScript("OnUpdate", THROTTLER:Hook('update_unitframe_' .. inst.unit, function()
            local inRange, checkedRange = UnitInRange(inst.unit);
            if (checkedRange and not inRange) then
                inst.frame:SetAlpha(0.25);
            else
                inst.frame:SetAlpha(1);
            end
        end))
    end
end

function CUnitFrame:Construct(unit, parent, groupOrder)
    local inst = { unit = unit, parent = parent or d3ui_Superframe, groupOrder = groupOrder }
    local config = CONSTS.UNIT_CONFIGS[unit]
    if (groupOrder) then
        config = CONSTS.UNIT_CONFIGS[groupOrder]
    end
    inst.config = config

    setmetatable(inst, self)
    self.__index = self

    return inst
end

local IUnitFrame = {}

function IUnitFrame:Load(unit, parent, groupOrder)
    local inst = CUnitFrame:Construct(unit, parent, groupOrder)

    inst:CreateOuterFrame()
    inst:CreateHealthFrame()

    if (inst.config.SPECIALS.auras) then
        inst.auraFrame = d3ui.AuraFrame:Load(unit, inst.frame)
    end

    inst:AddEventHandlers()

    inst:HandleChange()
    inst:UpdateThreatValues()
    inst:UpdateHealPredictionValues()

    if (inst.config.ROLE == 'party' or inst.config.ROLE == 'raid') then
        inst:UpdateRoleIcon()
        inst:UpdateLoggedInStatus()
    end


    return inst
end



d3ui.CUnitFrame = IUnitFrame