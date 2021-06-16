local unitConfigs = {
    player = {
        POSITION = { POINT = 'CENTER', X = 0, Y = 100 },
    },
    target = {
        POSITION = { POINT = 'CENTER', X = 0, Y = -35 },
    },
}

local ICastBar = {}

function ICastBar:CreateFrame()
    self.frame = CreateFrame("StatusBar", "d3ui_CCastBar_" .. self.unit, self.parentFrame, BackdropTemplateMixin and "BackdropTemplate")
    local unitConfig = unitConfigs[self.unit]

    self.frame:SetSize(192, 6)
    self.frame:SetFrameStrata("HIGH")
    self.frame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP)
    self.frame:SetPoint(unitConfig.POSITION.POINT, unitConfig.POSITION.X, unitConfig.POSITION.Y)


    local texture = self.frame:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture(CONSTS.TEXTURES.CASTBAR)

    self.frame:SetBackdrop({ bgFile = CONSTS.TEXTURES.CASTBAR_BACKDROP })
    self.frame:SetStatusBarTexture(texture)
    self.frame:SetStatusBarColor(CONSTS.COLORS.BASE.r, CONSTS.COLORS.BASE.g, CONSTS.COLORS.BASE.b, 1)


    self.frame.deltaText = UTIL:AddText(self.frame)
    self.frame.deltaText:SetPoint("RIGHT", -2, 10)
    self.frame.nameText = UTIL:AddText(self.frame)
    self.frame.nameText:SetPoint("LEFT", 2, 10)

    self.frame:Hide()
end

function ICastBar:ApplyColor(notInterruptible)
    if (self.channeling) then
        self.frame:SetStatusBarColor(CONSTS.COLORS.CASTBAR_NORMAL_CHANNEL.r, CONSTS.COLORS.CASTBAR_NORMAL_CHANNEL.g, CONSTS.COLORS.CASTBAR_NORMAL_CHANNEL.b, 1)
    else
        if (notInterruptible) then
            self.frame:SetStatusBarColor(CONSTS.COLORS.CASTBAR_PROTECTED.r, CONSTS.COLORS.CASTBAR_PROTECTED.g, CONSTS.COLORS.CASTBAR_PROTECTED.b, 1)
        else
            self.frame:SetStatusBarColor(CONSTS.COLORS.CASTBAR_NORMAL.r, CONSTS.COLORS.CASTBAR_NORMAL.g, CONSTS.COLORS.CASTBAR_NORMAL.b, 1)
        end
    end
end

function prec_print(v, prec)
    local format = '%.' .. prec .. 'f'
    return string.format(format, v)
end


function ICastBar:ShowCast()
    self.channeling = nil
    self.casting = true
    local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(self.unit);

    self.frame.nameText:SetText(name)

    self.value = (GetTime() - (startTime / 1000));
    self.maxValue = (endTime - startTime) / 1000;

    self:ApplyColor(notInterruptible)

    self.frame:SetMinMaxValues(0, self.maxValue)
    self.frame:SetValue(self.value)
    self.frame:Show()
end

function ICastBar:ShowChannel(...)
    local unit = ...;
    if (unit ~= self.unit) then return end;
    self.channeling = true
    self.casting = nil

    local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitChannelInfo(self.unit);
    self.frame.nameText:SetText(name)
    self:ApplyColor(notInterruptible)

    self.value = ((endTime or 0) / 1000) - GetTime();
    self.maxValue = ((endTime or 0) - startTime) / 1000;


    self.frame:SetMinMaxValues(0, self.maxValue);
    self.frame:SetValue(self.value)
    self.frame:Show()
end

function ICastBar:AddEventHandlers()
    local events = {}
    local unitEvents = {}
    local inst = self

    function unitEvents:UNIT_SPELLCAST_START(...)
        inst:ShowCast()
    end

    function unitEvents:UNIT_SPELLCAST_STOP(...)
        inst.frame:Hide()
    end

    function unitEvents:UNIT_SPELLCAST_INTERRUPTED(...)
        inst.frame:Hide()
    end

    function events:UNIT_SPELLCAST_CHANNEL_START(...)
        inst:ShowChannel(...)
    end

    function events:UNIT_SPELLCAST_CHANNEL_STOP(...)
        local unit = ...;
        if (unit ~= inst.unit) then return end;
        inst.frame:Hide()
    end

    if (inst.unit == 'target') then
        function events:PLAYER_TARGET_CHANGED(...)
            local castName =  UnitCastingInfo(inst.unit)
            if(castName) then
                inst:ShowCast(...)
                return
            end

            local channelName =  UnitChannelInfo(inst.unit)
            if(channelName) then
                inst:ShowChannel(inst.unit)
                return
            end

            inst.frame:Hide()
        end
    end

    UTIL:RegisterEvents(self.frame, events, unitEvents, self.unit)

    inst.frame:HookScript("OnUpdate", function(self, elapsed)
        inst.elapsed = inst.elapsed + elapsed
        if (inst.value >= inst.maxValue) then inst.frame:Hide() end;

        if (inst.channeling) then
            inst.value = inst.value - elapsed
            if (inst.elapsed >= .05) then
                inst.elapsed = 0
                inst.frame.deltaText:SetText(prec_print(inst.value, 2))
            end
        else
            inst.value = inst.value + elapsed
            if (inst.elapsed >= .05) then
                inst.elapsed = 0
                inst.frame.deltaText:SetText(prec_print(inst.maxValue - inst.value, 2))
            end
        end

        inst.frame:SetValue(inst.value);
    end)
end

function ICastBar:Construct(unit, parentFrame)
    local inst = {
        elapsed = 0,
        unit = unit,
        parentFrame = parentFrame,
        notInterruptible = false,
        channeling = false

    }
    setmetatable(inst, self)
    self.__index = self

    return inst
end

local CCastBar = {}

function CCastBar:Load(unit, parentFrame)
    local inst = ICastBar:Construct(unit, parentFrame)
    inst:CreateFrame()
    inst:AddEventHandlers()
end


d3ui.CCastBar = CCastBar