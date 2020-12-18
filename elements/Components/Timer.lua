local CTimer = {
    endsAt = nil
}

function CTimer:SetTimer(endsAt)
    self.endsAt = endsAt
    self.frame:Show()
end

function CTimer:Update()
    if (self.endsAt) then
        self.frame:Show()
        if (GetTime() < self.endsAt) then
            local remainingSeconds = self.endsAt - GetTime()
            self.frame.text:SetText(UTIL:SecondsToTime(remainingSeconds, self.plain))
        else
            self.frame:Hide()
        end
    else
        self.frame:Hide()
    end
end

function CTimer:CreateFrame()
    local frame = CreateFrame("Frame", nil, self.parent)
    frame:SetAllPoints(self.parent)
    frame:SetFrameStrata("HIGH")
    frame:SetFrameLevel(100)
    frame.text = UTIL:AddText(frame)
    frame.text:SetFont(CONSTS.FONTS.BASE, 12, 'OUTLINE')
    frame.text:SetPoint(self.pointConfig.point or 'BOTTOMRIGHT', self.pointConfig.x or 0, self.pointConfig.y or 0)
    frame.text:SetPoint(self.pointConfig.point or 'BOTTOMRIGHT', self.pointConfig.x or 0, self.pointConfig.y or 0)

    self.frame = frame
end


function CTimer:AddEventHandlers()
    self.frame:HookScript("OnUpdate", THROTTLER:Hook('update_timer_' .. self.identifier, function()
        self:Update()
    end))
end

function CTimer:Construct(parent, identifier, pointConfig, plain)
    local inst = { parent = parent, identifier = identifier or 0, pointConfig = pointConfig, plain = plain or false }
    setmetatable(inst, self)
    self.__index = self
    return inst
end

ITimer = {}

function ITimer:Load(parent, i, pointConfig, plain)
    local inst = CTimer:Construct(parent, i, pointConfig, plain)
    inst:CreateFrame()
    inst:AddEventHandlers()

    return inst
end