ClarityTemplates = {}

local RESOURCES = {
    ['Arcane Intellect'] = 135932,
    ['Ice Barrier'] = 135988,
}

local defaultFrameConfig = {
    edge = "Interface\\AddOns\\d3ui\\inc\\border-solid.tga",
    X = 0,
    Y = 0
}

local IClarityArea = {}

local AreaConfigs = {
    COOLDOWN = {
        W = 235,
        H = 36,
        POINT = 'BOTTOMLEFT',
        X = 0,
        Y = 0,
        op = 1
    },
    STATUS = {
        W = 235,
        H = 200,
        POINT = 'TOP',
        X = 0,
        Y = 0,
        op = 1
    },
    STATUSBAR = {
        W = 128,
        H = 400,
        POINT = 'BOTTOMLEFT',
        X = 0,
        Y = -40,
        op = -1,
        vertical = true
    },
    UPTIME = {
        W = 235,
        H = 100,
        POINT = 'TOPRIGHT',
        X = 0,
        Y = 0,
        op = -1
    },
    CC = {
        W = 235,
        H = 36,
        POINT = 'TOPLEFT',
        X = 0,
        Y = 0,
        op = 1
    },
    MOBILITY = {
        W = 235,
        H = 36,
        POINT = 'BOTTOMRIGHT',
        X = 0,
        Y = 0,
        op = -1
    },
}

function tl(T)
    local count = 0
    for _, d in pairs(T) do
        if (d) then
            count = count + 1
        end
    end
    return count
end

function IClarityArea:Construct(areaDescriptor, point)
    local inst = {
        point = point,
        x = 0,
        y = 0,
        tail = 0,
        frames = {}
    }

    setmetatable(inst, self)
    self.__index = self

    local config = AreaConfigs[areaDescriptor]

    inst.frame = CreateFrame('Frame', 'ClarityArea_' .. areaDescriptor, d3ui_ClaritySuperframe)
    inst.frame:SetSize(config.W, config.H)
    inst.frame:SetPoint(config.POINT, config.X, config.Y)
    inst.op = config.op
    inst.vertical = config.vertical

    return inst
end

local IC_SPACE = 2

function IClarityArea:Reposition(ard)
    local offs = 0
    for i = 1, self.tail do
        local fr = self.frames[i]
        if (fr.shown) then
            fr:ClearAllPoints()
            if (self.vertical) then
                fr:SetPoint(self.point, self.x, self.y + (self.op * (32 * offs)) + (self.op * (IC_SPACE * offs)))
            else
                fr:SetPoint(self.point, self.x + (self.op * (32 * offs)) + (self.op * (IC_SPACE * offs)), self.y)
            end
            offs = offs + 1
        end
    end
end


function IClarityArea:GetItemShift()
    return self.x + (self.op * (32 * self.tail)) + IC_SPACE
end

CooldownArea = IClarityArea:Construct('COOLDOWN', 'BOTTOMLEFT')
CCArea = IClarityArea:Construct('CC', 'BOTTOMLEFT')
MobilityArea = IClarityArea:Construct('MOBILITY', 'BOTTOMRIGHT')
UptimeArea = IClarityArea:Construct('UPTIME', 'TOPRIGHT')
StatusArea = IClarityArea:Construct('STATUS', 'TOP')
StatusBarArea = IClarityArea:Construct('STATUSBAR', 'BOTTOMLEFT')


local areas = {
    status = StatusArea,
    statusBar = StatusBarArea,
    uptime = UptimeArea,
    cc = CCArea,
    cooldown = CooldownArea,
    mobility = MobilityArea,
}


function CreateClarityActionButton(area, icon, bind)
    local areaConfig = areas[area]

    local frame = CreateFrame('Frame', nil, areaConfig.frame, BackdropTemplateMixin and "BackdropTemplate")
    frame.icon = icon

    areaConfig.tail = areaConfig.tail + 1
    areaConfig.frames[areaConfig.tail] = frame
    frame:SetSize(32, 32)
    frame:SetPoint(areaConfig.point, areaConfig:GetItemShift(), areaConfig.y)
    frame.texture = frame:CreateTexture(nil, "BACKGROUND")
    frame.texture:SetPoint('TOPLEFT', 2, -2)
    frame.texture:SetPoint('BOTTOMRIGHT', -2, 2)
    frame.texture:SetSize(32, 32)
    frame.texture:SetTexCoord(0.1, .9, 0.1, .9)
    frame.texture:SetTexture(icon)

    frame.overlay = frame:CreateTexture(nil, "ARTWORK")
    frame.overlay:SetPoint('TOPLEFT', 2, -2)
    frame.overlay:SetPoint('BOTTOMRIGHT', -2, 2)
    frame.overlay:SetTexture(CONSTS.TEXTURES.OVERLAY)
    frame.overlay:SetAlpha(.15)

    frame.timer = ITimer:Load(frame, UTIL:RSTR(8), { point = 'CENTER', x = 0, y = 0 }, true)
    frame.timer.frame.text:SetFont(CONSTS.FONTS.BASE, 16, 'OUTLINE')

    frame:SetBackdrop({ edgeFile = 'Interface\\AddOns\\d3ui\\inc\\border-solid-2.blp', edgeSize = 4 })
    frame:SetBackdropBorderColor(40 / 255, 40 / 255, 40 / 255, .8)

    frame:Hide()

    if (bind) then
        local bindText = frame:CreateFontString(nil, "ARTWORK")
        bindText:SetPoint("BOTTOMRIGHT", -2, -2)
        bindText:SetFont(CONSTS.FONTS.BASE, 16, "OUTLINE")
        bindText:SetText(bind)
        frame.bindText = bindText
    end

    frame.chargesText = frame:CreateFontString(nil, "ARTWORK")
    frame.chargesText:SetPoint("TOPRIGHT", -2, 2)
    frame.chargesText:SetFont(CONSTS.FONTS.BASE, 16, "OUTLINE")

    function frame:SetItemAlpha(n)
        frame.texture:SetAlpha(n)
        if (bind) then frame.bindText:SetAlpha(n) end;
        frame.chargesText:SetAlpha(n)
    end

    function frame:PShow()
        if (frame.shown) then return end;
        frame.shown = true
        frame:Show()
        areaConfig:Reposition()
    end

    function frame:PHide()
        if (not frame.shown) then return end;
        frame.enabled = false
        frame.shown = false
        frame:Hide()
        areaConfig:Reposition()
    end

    function frame:Enable()
        if (frame.enabled) then return end;
        frame.enabled = true
        self:PShow()
        frame:SetItemAlpha(1)
        areaConfig:Reposition()
    end

    function frame:Disable(cooldownDuration)
        frame.enabled = false
        frame:SetItemAlpha(.3)
        areaConfig:Reposition()

        if (cooldownDuration) then
            frame.timer:SetTimer(cooldownDuration)
        end
    end


    return frame
end

function CreateClarityStatusBar(area, name)
    local areaConfig = areas[area]
    local frame = CreateFrame('Frame', nil, areaConfig.frame, BackdropTemplateMixin and "BackdropTemplate")
    frame:SetSize(128, 8)

    areaConfig.tail = areaConfig.tail + 1
    areaConfig.frames[areaConfig.tail] = frame

    local statusBar = CreateFrame('StatusBar', nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    statusBar:SetSize(128, 8)
    statusBar:SetPoint('CENTER', 0, 0)
    statusBar:SetFrameStrata("HIGH")
    statusBar:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_HP)

    statusBar.nameText = UTIL:AddText(statusBar)
    statusBar.nameText:SetPoint("LEFT", 2, 10)
    statusBar.nameText:SetText(name)

    statusBar.deltaText = UTIL:AddText(statusBar)
    statusBar.deltaText:SetPoint("RIGHT", -2, 10)
    statusBar.deltaText:SetText('')

    local texture = statusBar:CreateTexture(nil, "BACKGROUND")
    texture:SetTexture(CONSTS.TEXTURES.STATUSBAR)
    statusBar:SetBackdrop({ bgFile = CONSTS.TEXTURES.STATUSBAR_BACKDROP })
    statusBar:SetStatusBarTexture(texture)
    statusBar:SetStatusBarColor(60 / 255, 160 / 255, 217 / 255, 1)

    function frame:PShow()
        if (frame.shown) then return end;
        frame.shown = true
        frame:Show()
        areaConfig:Reposition('d')
    end

    function frame:PHide()
        if (not frame.shown) then return end;
        frame.enabled = false
        frame.shown = false
        frame:Hide()
        areaConfig:Reposition()
    end

    frame.statusBar = statusBar
    frame:Hide()

    frame:HookScript("OnUpdate", THROTTLER:Hook('_clarity_statusbar_'..name, function(_, elapsed)
        if (not frame.expiresAt or not frame.current) then return end;

        frame.current = frame.current - elapsed
        if (frame.current <= 0) then
            frame.current = nil
            frame.expiresAt = nil
            frame:Hide()
        else
            frame.statusBar:SetValue(frame.current)
            frame.statusBar.deltaText:SetText(UTIL:SecondsToTime(frame.current))
        end
    end, 0.05))

    return frame
end

function ClarityTemplates:AuraIcon(name, stateToken, positiveLookup, lookupIcon, combatOnly)
    return {
        depends = {
            [stateToken] = true,
            always = true,
            dead = true,
            combat = true
        },
        handler = function(state, ctx)
            if (combatOnly and not state.combat) then
                ctx.iconFrame:PHide()
                return
            end;

            if (positiveLookup) then
                if (state[stateToken] and not state.dead) then
                    ctx.iconFrame:PShow()
                else
                    ctx.iconFrame:PHide()
                end
            else
                if ((not state[stateToken]) and not state.dead) then
                    ctx.iconFrame:PShow()
                else
                    ctx.iconFrame:PHide()
                end
            end
        end,
        createCtx = function()
            local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(lookupIcon or name)
            local defaultFrameConfig
            local shard, ctx = SpawnCtx()

            ctx.iconFrame = CreateClarityActionButton('status', icon)

            return shard, ctx
        end,
        initialize = function()
            local found = AuraUtil.FindAuraByName(name, 'player')
            ClarityGlobalState:Dispatch(stateToken, found)
        end,
        actions = {
            [1] = {
                event = 'UNIT_AURA',
                action = function()
                    local found = AuraUtil.FindAuraByName(name, 'player')
                    ClarityGlobalState:Dispatch(stateToken, found)
                end
            }
        }
    }
end

function ClarityTemplates:CombatUptime(name, stateToken, positiveLookup, bind)
    return {
        depends = {
            [stateToken] = true,
            always = true,
            combat = true
        },
        handler = function(state, ctx)
            local lookupBool = state[stateToken]

            local _, cooldownDuration = GetSpellCooldown(name)
            local spellReady = (cooldownDuration == 0) or cooldownDuration <= IClarity.dirtyStates.gcd

            if (state.combat and spellReady) then
                if ((lookupBool and positiveLookup) or (not lookupBool and not positiveLookup)) then
                    ctx.iconFrame:PShow()
                else
                    ctx.iconFrame:PHide()
                end
            else
                ctx.iconFrame:PHide()
            end
        end,
        createCtx = function()
            local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(name)

            local shard, ctx = SpawnCtx()

            ctx.iconFrame = CreateClarityActionButton('uptime', icon, bind)

            return shard, ctx
        end,
        initialize = function()
            local found = AuraUtil.FindAuraByName(name, 'player')
            ClarityGlobalState:Dispatch(stateToken, found)
        end,
        actions = {
            [1] = {
                event = 'UNIT_AURA',
                action = function()
                    local found = AuraUtil.FindAuraByName(name, 'player')
                    ClarityGlobalState:Dispatch(stateToken, found)
                end
            }
        }
    }
end

function ClarityTemplates:CombatStatusBar(name, stateToken, area)
    return {
        depends = {
            [stateToken] = true,
            always = true,
            combat = true
        },
        handler = function(state, ctx)
            if (state.combat) then
                if (ctx.frame.expiresAt) then
                    return
                end

                local name, icon, count, debuffType, duration, expirationTime = AuraUtil.FindAuraByName(name, 'player')

                if (duration) then
                    ctx.frame.expiresAt = expirationTime
                    ctx.frame.duration = duration
                    ctx.frame.current = expirationTime - GetTime()
                    ctx.frame.min = expirationTime - duration
                    ctx.frame.statusBar:SetMinMaxValues(0, duration)
                    ctx.frame.statusBar:SetValue(ctx.frame.current)
                    ctx.frame.statusBar.deltaText:SetText(UTIL:SecondsToTime(ctx.frame.current))
                    ctx.frame:PShow()
                else
                    ctx.frame:PHide()
                end
            else
                ctx.frame:PHide()
            end
        end,
        createCtx = function()
            local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(name)
            local currentCharges, maxCharges = GetSpellCharges(name)
            local shard, ctx = SpawnCtx()

            ctx.frame = CreateClarityStatusBar(area or 'statusBar', name)

            return shard, ctx
        end,
        initialize = function()
            local found = AuraUtil.FindAuraByName(name, 'player')
            ClarityGlobalState:Dispatch(stateToken, found)
        end,
        actions = {
            [1] = {
                event = 'UNIT_AURA',
                action = function()
                    local found = AuraUtil.FindAuraByName(name, 'player')
                    ClarityGlobalState:Dispatch(stateToken, found)
                end
            }
        }
    }
end

function ClarityTemplates:CombatCooldown(name, bind, area)
    return {
        depends = {
            always = true,
            combat = true
        },
        handler = function(state, ctx)
            local start, cooldownDuration = GetSpellCooldown(name)

            if (state.combat) then
                local spellReady = (cooldownDuration == 0) or (cooldownDuration or 0) <= IClarity.dirtyStates.gcd
                if (ctx.iconFrame.hasCharges) then
                    local currentCharges = GetSpellCharges(name)
                    ctx.iconFrame.chargesText:SetText(currentCharges)
                end

                ctx.iconFrame:PShow()

                if (spellReady) then
                    ctx.iconFrame:Enable(1)
                else
                    ctx.iconFrame:Disable(start + cooldownDuration)
                end
            else
                ctx.iconFrame:PHide()
            end
        end,
        createCtx = function()
            local name, rank, icon, castTime, minRange, maxRange, spellId = GetSpellInfo(name)
            local currentCharges, maxCharges = GetSpellCharges(name)
            local shard, ctx = SpawnCtx()

            ctx.iconFrame = CreateClarityActionButton(area or 'cooldown', icon, bind)
            if (maxCharges and (maxCharges > 1)) then
                ctx.iconFrame.hasCharges = true
            else
                ctx.iconFrame.hasCharges = false
            end
            return shard, ctx
        end
    }
end

