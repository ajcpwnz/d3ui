CAuraIcon = {}


function CAuraIcon:CreateFrame()
    local frame = CreateFrame('Frame', nil, self.parent)
    frame:SetSize(self.sizes.W, self.sizes.H)
    frame:SetPoint('CENTER', 0, 0)

    local texture = frame:CreateTexture(nil, 'ARTWORK')
    texture:SetAllPoints(frame)
    texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)
    self.texture = texture 

    self.frame = frame

    self.timer = ITimer:Load(self.frame, self.name..self.unit, {point = 'BOTTOMRIGHT', x = 1, y = -1}, true)
    self.timer.frame.text:ClearAllPoints()
    self.timer.frame.text:SetPoint('TOPRIGHT', 0, 0)
    self.timer.frame.text:SetFont(CONSTS.FONTS.BASE, 10, 'OUTLINE')
    self.frame:Hide()
end

function CAuraIcon:HandleChange()
    local found, icon, count, debuffType, duration, expirationTime = AuraUtil.FindAuraByName(self.name, self.unit)
    if (found) then 
        self.texture:SetTexture(icon)
        self.texture:SetAllPoints(self.frame)
        self.texture:SetTexCoord(0.05, 0.95, 0.05, 0.95)

        self.timer:SetTimer(expirationTime)
        self.frame:Show()
    else
        self.frame:Hide()
    end
end

function CAuraIcon:Construct(name, unit, sizes, parent)
    local inst = { name = name, unit = unit, parent = parent, sizes = sizes }
    setmetatable(inst, self)
    self.__index = self
    return inst
end


local IAuraIcon = {}

function IAuraIcon:Load(name, unit, sizes, parent)
    local inst = CAuraIcon:Construct(name, unit, sizes, parent)
    inst:CreateFrame()
    inst:HandleChange()

    return inst
end

d3ui.AuraIcon = IAuraIcon