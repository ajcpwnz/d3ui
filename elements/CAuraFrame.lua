CAuraFrame = {}

local MAX_ICS = 40
local IC_W = 32
local IC_H = IC_W * 0.75
local IC_SPACE = 4
local IC_SPACE_Y = 4
local ROW_ICONS = 5

function CAuraFrame:CreateOuterFrame()
    self.outerFrame = CreateFrame('Frame', 'd3ui_AuraFrame_outer_' .. self.unit, self.parent)
    local W = (ROW_ICONS * IC_W) + ((ROW_ICONS - 1) * IC_SPACE)
    local H = (MAX_ICS / ROW_ICONS) * IC_H + (((MAX_ICS / ROW_ICONS) - 1) * IC_H)

    self.outerFrame:SetSize(W, H)
    self.outerFrame:SetPoint('TOPLEFT', 0, H + 25)
    self.outerFrame:Show()
end

function CAuraFrame:CreateAuraFrames()
    local auraFrames = {}
    for idx = 1, 40 do
        local frame = CreateFrame('Frame', nil, self.outerFrame, BackdropTemplateMixin and "BackdropTemplate")
        frame:SetBackdrop({ edgeFile = "Interface\\AddOns\\d3ui\\inc\\border-solid-2.tga", edgeSize = 4 })

        frame:SetScript("OnEnter", function()
            GameTooltip:SetOwner(frame, "ANCHOR_BOTTOMLEFT")
            GameTooltip:SetUnitAura(self.unit, frame.idx, frame.filterStr)
        end)

        frame:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        frame:EnableMouse(true)

        frame.texture = frame:CreateTexture(nil, "BACKGROUND")
        frame.texture:SetPoint('TOPLEFT', 2.5, -2.5)
        frame.texture:SetPoint('BOTTOMRIGHT', -2.5, 2.5)

        frame.overlay = frame:CreateTexture(nil, "ARTWORK")
        frame.overlay:SetPoint('TOPLEFT', 2.5, -2.5)
        frame.overlay:SetPoint('BOTTOMRIGHT', -2.5, 2.5)
        frame.overlay:SetTexture(CONSTS.TEXTURES.OVERLAY)
        frame.overlay:SetAlpha(.15)

        frame.stacksText = UTIL:AddText(frame)
        frame.stacksText:SetFont(CONSTS.FONTS.BASE, 10, 'OUTLINE')
        frame.stacksText:SetPoint('TOPRIGHT', 1, 1)

        frame.timer = ITimer:Load(frame, i, {point = 'BOTTOMRIGHT', x = 1, y = -1})

        auraFrames[idx] = frame
    end

    self.auraFrames = auraFrames
end

function CAuraFrame:DisplayAuras()
    local X_OFFSET = 4
    local Y_OFFSET = 0
    local boxIdx = 1;
    UTIL:AuraIterator(function(idx, ...)
        local box = self.auraFrames[boxIdx]
        box.idx = idx
        box.filterStr = 'HELPFUL'
        local name, icon, count, debuffType, duration, expirationTime = ...
        box.texture:SetTexture(icon)
        box:SetSize(IC_W, IC_H)
        box:SetPoint("BOTTOMLEFT", X_OFFSET, Y_OFFSET)
        box.texture:SetTexCoord(.05, .95, 0.1625, 0.8375)

        box.timer:SetTimer(expirationTime)

        -- box.cooldownFrame:SetCooldown(expirationTime - duration, duration)
        box:SetBackdropBorderColor(CONSTS.COLORS.BUFF.r, CONSTS.COLORS.BUFF.g, CONSTS.COLORS.BUFF.b, 1)
        box:Show()

        if (count ~= 0 and count ~= 1) then
            box.stacksText:SetText(count)
        else
            box.stacksText:SetText('')
        end

        X_OFFSET = X_OFFSET + IC_W + IC_SPACE
        if (math.fmod(idx, ROW_ICONS) == 0) then
            X_OFFSET = 4
            Y_OFFSET = Y_OFFSET + IC_H + IC_SPACE_Y
        end
        boxIdx = boxIdx + 1
    end,
        function(idx)
        end, 'HELPFUL', self.unit)

    X_OFFSET = 4
    if (boxIdx > 1) then
        Y_OFFSET = Y_OFFSET + IC_H + IC_SPACE_Y
    end

    UTIL:AuraIterator(function(idx, ...)
        local box = self.auraFrames[boxIdx]
        box.idx = idx
        box.filterStr = 'HARMFUL PLAYER'
        local name, icon, count, debuffType, duration, expirationTime = ...

        box.texture:SetTexture(icon)

        box:SetSize(IC_W, IC_H)
        box:SetPoint("BOTTOMLEFT", X_OFFSET, Y_OFFSET)
        box.texture:SetTexCoord(.05, .95, 0.1625, 0.8375)

        box.timer:SetTimer(expirationTime)

        if (count ~= 0 and count ~= 1) then
            box.stacksText:SetText(count)
        else
            box.stacksText:SetText('')
        end

        box:SetBackdropBorderColor(CONSTS.COLORS.DEBUFF.r, CONSTS.COLORS.DEBUFF.g, CONSTS.COLORS.DEBUFF.b, 1)
        box:Show()

        X_OFFSET = X_OFFSET + IC_W + IC_SPACE
        if (math.fmod(idx, ROW_ICONS) == 0) then
            X_OFFSET = 4
            Y_OFFSET = Y_OFFSET + IC_H + IC_SPACE_Y
        end

        boxIdx = boxIdx + 1
    end,
        function(idx)
        end, 'HARMFUL PLAYER', self.unit)

    for idx = boxIdx, 40 do
        local box = self.auraFrames[idx]
        box:Hide()
    end
end


function CAuraFrame:AddEventHandlers()
    local inst = self
    local unitEvents = {}

    function unitEvents:UNIT_AURA(...)
        inst:DisplayAuras()
    end

    UTIL:RegisterEvents(inst.outerFrame, {}, unitEvents, inst.unit)
end

function CAuraFrame:Construct(unit, parent, groupOrder)
    local inst = { unit = unit, parent = parent or d3ui_Superframe, }
    setmetatable(inst, self)
    self.__index = self
    return inst
end



local IAuraFrame = {}

function IAuraFrame:Load(unit, parent)
    local inst = CAuraFrame:Construct(unit, parent)

    inst:CreateOuterFrame()
    inst:CreateAuraFrames()
    inst:AddEventHandlers()

    return inst
end

d3ui.AuraFrame = IAuraFrame