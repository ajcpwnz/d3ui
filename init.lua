d3ui = {}

function d3ui:OnInit()
    print('d3ui Loaded')
    --
    d3ui:LoadElems()
end

function d3ui:HideBlizz()
     PlayerFrame:SetScript("OnEvent", nil);
     PlayerFrame:Hide();

     FocusFrame:SetScript("OnEvent", nil);
     FocusFrame:Hide();

     CastingBarFrame:UnregisterAllEvents()
     CastingBarFrame:Hide();

     TargetFrame:UnregisterAllEvents()
     TargetFrame:Hide();

     --StatusTrackingBarManager:Hide()
     --StatusTrackingBarManager:UnregisterAllEvents()
     MainMenuBarArtFrame.LeftEndCap:Hide();
     MainMenuBarArtFrame.RightEndCap:Hide()
     MainMenuBarArtFrameBackground:Hide()
     MainMenuBarArtFrame:Hide()

    for i=1,12 do
        _G["ActionButton" .. i]:Hide()
        _G["ActionButton" .. i]:UnregisterAllEvents()
        _G["ActionButton" .. i]:SetAttribute("statehidden", true)

        _G["MultiBarBottomLeftButton" .. i]:Hide()
        _G["MultiBarBottomLeftButton" .. i]:UnregisterAllEvents()
        _G["MultiBarBottomLeftButton" .. i]:SetAttribute("statehidden", true)

        _G["MultiBarBottomRightButton" .. i]:Hide()
        _G["MultiBarBottomRightButton" .. i]:UnregisterAllEvents()
        _G["MultiBarBottomRightButton" .. i]:SetAttribute("statehidden", true)

        _G["MultiBarRightButton" .. i]:Hide()
        _G["MultiBarRightButton" .. i]:UnregisterAllEvents()
        _G["MultiBarRightButton" .. i]:SetAttribute("statehidden", true)

        _G["MultiBarLeftButton" .. i]:Hide()
        _G["MultiBarLeftButton" .. i]:UnregisterAllEvents()
        _G["MultiBarLeftButton" .. i]:SetAttribute("statehidden", true)
    end

     StanceBarFrame:UnregisterAllEvents()
     StanceBarFrame:Hide()
     StanceBarFrame:SetParent(d3ui_InvisibleFrame)
     StanceBarFrame:ClearAllPoints()

     MainMenuBar:SetParent(d3ui_InvisibleFrame)

     PetActionBarFrame:SetParent(d3ui_InvisibleFrame)
     PetActionBarFrame:ClearAllPoints()
     PetActionBarFrame:SetPoint('TOP', 0 ,10)
     PetActionBarFrame:SetScript("OnEvent", nil);
     PetActionBarFrame:Hide()

     ChatFrame1:SetSize(400, 1050)
     ChatFrame1.SetSize = nop

     MicroButtonAndBagsBar:SetParent(d3ui_InvisibleFrame)
end

function LoadTestFrame()
    CreateFrame("Frame", "ttt_test", d3ui_Superframe, BackdropTemplateMixin and "BackdropTemplate")
    ttt_test:SetSize(128, 128 * 0.75)
    ttt_test:SetPoint("CENTER", 0, 500)
    ttt_test:SetBackdrop({ edgeFile = "Interface\\AddOns\\d3ui\\inc\\border-solid.tga", edgeSize=16 })
    ttt_test.texture = ttt_test:CreateTexture(nil,"BACKGROUND")


    -- 0.4375
    ttt_test.texture:SetPoint('TOPLEFT', 4, -4)
    ttt_test.texture:SetPoint('BOTTOMRIGHT', -4, 4)

    ttt_test.texture:SetTexture('2')
    ttt_test.texture:SetTexCoord(.05, 0.95, 0.1625, 0.8375)

end

function d3ui:LoadElems()
    d3ui.PlayerFrame:Load()
    d3ui.PowerDisplay:Load()
    d3ui.PointsDisplay:Load()
    d3ui.CCastBar:Load('player', d3ui_PlayerFrame)

    d3ui.MirrorTimers:Load()


    local targetFrame = d3ui.CUnitFrame:Load('target')
    d3ui.CUnitFrame:Load('focus')
    --d3ui.CUnitFrame:Load('targettarget')

    d3ui.PartyFrame:Load()
    d3ui.CCastBar:Load('target', targetFrame.frame)

    d3ui.StatusTrackerBar:Load()

    IActionBar:Load()
    IStanceBar:Load()

    d3ui.Clarity:Load()
    --LoadTestFrame()
end

function deb()
   d3ui_Data.ActionBars = {}
--    CompactPartyFrame:Hide()
    -- CompactRaidFrameContainer:Hide()
    -- CompactRaidFrameContainer:UnregisterAllEvents()
end


function deb2()
    CompactPartyFrames:Hide()
end

local addonLoaded = false
local playerLoggedIn = false
local playerIsInWorld = false

function attemptLoad()
    if(not d3ui_Superframe) then print('Whoopsie') end

    if(addonLoaded and playerLoggedIn and playerIsInWorld) then
        d3ui:OnInit()
        d3ui_Superframe:Show()
        addonLoaded = false
        playerLoggedIn = false
        playerIsInWorld = false
    end
end

function main()
    CreateFrame("Frame", 'd3ui_Superframe', UIParent)

    d3ui_Superframe:SetAllPoints(UIParent)

    d3ui_Superframe:RegisterEvent("PLAYER_LOGIN")
    d3ui_Superframe:RegisterEvent("PLAYER_ENTERING_WORLD")
    d3ui_Superframe:RegisterEvent("ADDON_LOADED")
    d3ui_Superframe:RegisterEvent("UPDATE_BINDINGS")

    d3ui_Superframe:SetScript("OnEvent", function(self, event, addon, ...)
        if( event == "PLAYER_LOGIN" ) then
            playerLoggedIn = true
            attemptLoad()

            d3ui_Superframe:UnregisterEvent("PLAYER_LOGIN")
            d3ui_Superframe:Show()
        elseif( event == "PLAYER_ENTERING_WORLD"  ) then
            playerIsInWorld = true
            attemptLoad()

        elseif( event == "ADDON_LOADED" and ( addon == "d3ui" ) ) then
            d3ui:HideBlizz()
            addonLoaded = true
            attemptLoad()

        elseif( event == "UPDATE_BINDINGS" ) then
            print('UPDATE_BINDINGS event')

        -- hide in blizz ui
        elseif( event == "ADDON_LOADED" and ( addon == "Blizzard_ArenaUi" or addon == "Blizzard_CompactRaidFrames" ) ) then
            d3ui_Superframe:Hide()
        end
    end)

end

-- entrypoint
main()
