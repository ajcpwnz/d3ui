local UPDATE_DELAY = .5

IMirrorTimers = {
    [1] = false,
    [2] = false,
    [3] = false,

    EXHAUSTION= 1,
    BREATH = 2,
    FEIGNDEATH = 3,

    timers = {},
    elapsedTime = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
    }
}

local labels = {
    [1] = 'Fatigue',
    [2] = 'Breath',
    [3] = 'Feign death',
}

local START_OFFSET = 425

function IMirrorTimers:UpdateTimer(name)
    local lookupIdx = IMirrorTimers[name];
    local running = IMirrorTimers[lookupIdx];
    if(running) then
        IMirrorTimers[lookupIdx] = false
        IMirrorTimers.timers[lookupIdx]:Hide()
    else
        IMirrorTimers[lookupIdx] = true
        IMirrorTimers.timers[lookupIdx]:Show()
    end
end

function IMirrorTimers:UpdateTimers()
    for i = 1,3 do
        local lookupIdx = i;
        local name, initial, maxValue = GetMirrorTimerInfo(i)
        local running = (name ~= 'UNKNOWN');
        if(running) then
            IMirrorTimers[lookupIdx] = true
            IMirrorTimers.timers[lookupIdx]:Show()
        else
            IMirrorTimers[lookupIdx] = false
            IMirrorTimers.timers[lookupIdx]:Hide()
        end
    end
end

local colors = {
    [1] = {r = 235/255, g = 216/255, b = 43/255},
    [2] = {r = 60/255, g = 160/255, b = 216/255},
    [3] = {r = 214/255, g = 214/255, b = 214/255},
}

function IMirrorTimers:CreateFrame()
    for i = 1,3 do
        local timer = CreateFrame("StatusBar", "d3ui_MirrorTimer" .. i, d3ui_Superframe, BackdropTemplateMixin and "BackdropTemplate")

        timer:SetSize(192, 6)
        timer:SetFrameStrata("HIGH")
        timer:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP)
        timer:SetPoint("CENTER", 0, START_OFFSET + (20 * i))

        local texture = timer:CreateTexture(nil,"BACKGROUND")
        texture:SetTexture(CONSTS.TEXTURES.CASTBAR)

        timer:SetBackdrop({ bgFile = CONSTS.TEXTURES.CASTBAR_BACKDROP })
        timer:SetStatusBarTexture(texture)
        timer:SetStatusBarColor(colors[i].r, colors[i].g, colors[i].b, 1)

        local nameText = timer:CreateFontString(nil,"ARTWORK")
        local deltaText = timer:CreateFontString(nil,"ARTWORK")
        nameText:SetPoint("LEFT", 2, 8)
        deltaText:SetPoint("RIGHT", 0, 8)
        nameText:SetFont(CONSTS.FONTS.BASE, 11, "")
        deltaText:SetFont(CONSTS.FONTS.BASE, 11, "")
        nameText:SetText(labels[i])

        timer.deltaText = deltaText
        timer.nameText = nameText

        timer:HookScript("OnUpdate", function(self, elapsed)
            if(not IMirrorTimers[i]) then
                return
            else

                local name, initial, maxValue = GetMirrorTimerInfo(i)
                if(name == 'UNKNOWN') then
                    IMirrorTimers[i] = false
                    timer:Hide()
                    return
                end;
                IMirrorTimers.elapsedTime[i] = IMirrorTimers.elapsedTime[i] + elapsed
                if(IMirrorTimers.elapsedTime[i] > UPDATE_DELAY) then
                    IMirrorTimers.elapsedTime[i] = 0
                    local currentValue = GetMirrorTimerProgress(name)
                    timer:SetMinMaxValues(0, maxValue)
                    timer:SetValue(currentValue)
                end
            end
        end
        )

        timer:Hide()

        IMirrorTimers.timers[i] = timer
    end
end


local function HideBlizz()
    MirrorTimer1:UnregisterAllEvents()
    MirrorTimer1:SetScript("OnEvent", nil);
    MirrorTimer1:Hide()
    MirrorTimer2:UnregisterAllEvents()
    MirrorTimer2:SetScript("OnEvent", nil);
    MirrorTimer2:Hide()
    MirrorTimer3:UnregisterAllEvents()
    MirrorTimer3:SetScript("OnEvent", nil);
    MirrorTimer3:Hide()
end

function  IMirrorTimers:AddEventHandlers()
    local events = {}

    function events:MIRROR_TIMER_START(...)
        HideBlizz()
        IMirrorTimers:UpdateTimer(...)
    end

    function events:MIRROR_TIMER_STOP(...)
        HideBlizz()
        IMirrorTimers:UpdateTimer(...)
    end

    UTIL:RegisterEvents(d3ui_MirrorTimer3, events)
end


function IMirrorTimers:Load ()
   IMirrorTimers:CreateFrame()
   IMirrorTimers:AddEventHandlers()
   IMirrorTimers:UpdateTimers()
end

d3ui.MirrorTimers = IMirrorTimers