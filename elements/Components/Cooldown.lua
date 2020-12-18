EnslavedCooldown = {}

-- Get the sweet, sweet cooldown swipe functionality without actually drawing the cooldown
-- disable unusable gunk

function EnslavedCooldown:Load(name, parent)
    local frame = CreateFrame("Cooldown", name, parent, "CooldownFrameTemplate")
    frame:SetDrawBling(false)
    frame:SetDrawEdge(false)

    local timer = frame:GetRegions()

    timer.SetFontObject = nop
    timer.SetFont = nop

    timer:ClearAllPoints()
    timer.ClearAllPoints = nop

    timer:SetPoint("CENTER", button, "TOP", 0, 0)
    timer.SetPoint = nop

    timer:Hide()
    timer.Show = nop
    timer:SetText('')
    timer:SetAlpha(0)

    return frame
end