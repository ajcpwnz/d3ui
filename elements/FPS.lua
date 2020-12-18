local frame = CreateFrame('Frame', 'd3ui_FPS', d3ui_Superframe)
frame:SetPoint('TOPLEFT', 0,0)
frame:SetSize(24,16)
local text = frame:CreateFontString(nil, "ARTWORK")
text:SetAllPoints(frame)
text:SetFont(CONSTS.FONTS.BASE, 11, "")
frame.elapsed = 0

frame:HookScript("OnUpdate", function(self, elapsed)
    frame.elapsed = frame.elapsed + elapsed
    if(frame.elapsed >= 1) then
        frame.elapsed = 0
        text:SetText(floor(GetFramerate()))
    end
end)

frame:Show()


--for bag=0,4,1 do
--    for slot=1,GetContainerNumSlots(bag),1 do
--        local name=GetContainerItemLink(bag,slot)
--        if name and string.find(name,"ff9d9d9d")
--            then DEFAULT_CHAT_FRAME:AddMessage("- Selling "..name)
--            UseContainerItem(bag,slot)
--        end
--    end
--end



---
