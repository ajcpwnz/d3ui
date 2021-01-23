local d3ui_Button = CreateFrame("Button")
local d3ui_ButtonIndex = { __index = d3ui_Button }

local Lookup = {
    in_range = {
        ['spell'] = function(a, b)
            local sp = FindSpellBookSlotBySpellID(a)
            if (not sp) then return nil end
            return IsSpellInRange(sp, "spell", b)
        end,
        ['flyout'] = function() return nil end,
        ['empty'] = function() return nil end,
        ['macro'] = function() return nil end,
        ['summonmount'] = function() return 1 end,
        ['mount'] = function() return 1 end,
        ['item'] = IsItemInRange,
    },
    usable = {
        ['spell'] = IsUsableSpell,
        ['flyout'] = IsUsableSpell,
        ['empty'] = function() return nil end,
        ['macro'] = function() return true end,
        ['summonmount'] = function() return true end,
        ['mount'] = function() return true end,
        ['item'] = IsUsableItem,
    },
    cooldown = {
        ['spell'] = GetSpellCooldown,
        ['flyout'] = GetSpellCooldown,
        ['empty'] = function() return nil end,
        ['macro'] = function() return nil end,
        ['summonmount'] = function() return nil end,
        ['mount'] = function() return nil end,
        ['item'] = GetItemCooldown,
    },
    icon = {
        ['spell'] = function(id)
            local _, _, icon = GetSpellInfo(id)
            return icon
        end,
        ['flyout'] = function(id)
            local spellID = GetFlyoutSlotInfo(id, 1);
            local _, _, icon = GetSpellInfo(spellID)
            return icon
        end,
        ['item'] = function(id)
            local _, _, _, _, _, _, _, _, _, icon = GetItemInfo(id)
            return icon
        end,
        ['macro'] = function(id)
            local _, icon = GetMacroInfo(id)
            return icon
        end,
        ['summonmount'] = function(id)
            if (not id) then return nil end;
            local _, spellId = C_MountJournal.GetMountInfoByID(id)
            local _, _, icon = GetSpellInfo(spellId)
            return icon
        end,
        ['mount'] = function(id)
            if (not id) then return nil end;
            local _, spellId = C_MountJournal.GetMountInfoByID(id)
            local _, _, icon = GetSpellInfo(spellId)
            return icon
        end,
    },
    count = {
        ['spell'] = GetSpellCharges,
        ['item'] = function(id) local count = GetItemCount(id); return count, count end,
        ['macro'] = function(id) return nil end,
        ['summonmount'] = function(id) return nil end,
        ['mount'] = function(id) return nil end,
        ['empty'] = function() return nil end,
        ['flyout'] = function() return nil end,
    },
    tooltip = {
        ['spell'] = function(id)GameTooltip:SetSpellByID(id) end,
        ['item'] = function(id) 
            GameTooltip:SetHyperlink('item:' .. id)
        end,
        ['summonmount'] = function() return nil end,
        ['mount'] = function() return nil end,
        ['empty'] = function() return nil end,
        ['flyout'] = function(id, ref) 
            local title, description = GetFlyoutInfo(id)
            GameTooltip:SetOwner(ref, "ANCHOR_RIGHT");
            GameTooltip:AddLine(title, 1,1,1)
            GameTooltip:AddLine(description)
            GameTooltip:SetWidth(200)
            GameTooltip:Show()
        end,
        ['macro'] = function(id) return nil end,
    }
}

--
-- ADD UI ELEMENTS
--

function d3ui_Button:AddUIElements()
    local bar = self.bar

    self.Border:Hide()
    self.NormalTexture:SetTexture(nil)

    self:SetSize(bar.config.DISPLAY.SIZE, bar.config.DISPLAY.SIZE)


    if (bar.config.DISPLAY.ORIENTATION == 'HORIZONTAL') then
        self:SetPoint('TOP', 0, -(self._id - 1) * (bar.config.DISPLAY.SIZE + bar.config.DISPLAY.SPACE))
    else
        self:SetPoint('LEFT', (self._id - 1) * (bar.config.DISPLAY.SIZE + bar.config.DISPLAY.SPACE), 0)
    end

    local border = self:CreateTexture(nil, "OVERLAY")
    border:SetAllPoints(self)
    border:SetTexture(CONSTS.TEXTURES.BORDER_TEXTURE)
    --    border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, 1)
    border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, .8)
    border:SetAlpha(0)
    self.border = border

    local background = self:CreateTexture(nil, "BACKGROUND")
    background:SetPoint('TOPLEFT', 0,0)
    background:SetPoint('BOTTOMRIGHT', 0,0)
    background:SetTexture(CONSTS.TEXTURES.BTN_BACKGROUND)
    self.background = background
    
    local texture = self:CreateTexture(nil, "ARTWORK")
    texture:SetPoint('TOPLEFT', 2, -2)
    texture:SetPoint('BOTTOMRIGHT', -2, 2)
    texture:SetTexCoord(0.1, .9, 0.1, .9)
    self.texture = texture

    local overlay = self:CreateTexture(nil, "OVERLAY")
    overlay:SetPoint('TOPLEFT', 2, -2)
    overlay:SetPoint('BOTTOMRIGHT', -2, 2)
    overlay:SetAlpha(0)
    overlay:SetTexture(CONSTS.TEXTURES.BTN_OVERLAY)
    self.overlay = overlay

    local bindText = self:CreateFontString(nil, "OVERLAY")
    bindText:SetPoint("TOPRIGHT", -2, 2)
    bindText:SetFont(CONSTS.FONTS.BASE, bar.config.DISPLAY.SIZE * 0.5, "OUTLINE")
    self.bindText = bindText

    local chargesText = self:CreateFontString(nil, "OVERLAY")
    chargesText:SetPoint("BOTTOMRIGHT", -2, -2)
    chargesText:SetFont(CONSTS.FONTS.BASE, bar.config.DISPLAY.SIZE * 0.5, "OUTLINE")
    self.chargesText = chargesText


    self.timer = ITimer:Load(self, self:GetName(), { point = 'CENTER', x = 0, y = 0 }, true)
    self.timer.frame.text:SetFont(CONSTS.FONTS.BASE, 16, 'OUTLINE')

    local cooldown = EnslavedCooldown:Load(self:GetName() .. '_cooldown', self)
    cooldown:SetPoint('TOPLEFT', 2, -2)
    cooldown:SetEdgeTexture("Interface\\Cooldown\\edge")
    cooldown:SetPoint('BOTTOMRIGHT', -2, 2)
    self.cooldown = cooldown
end

function d3ui_Button:SetUpMeta()
    local buttonIndexes = {
        [0] = ((self.barId - 1) * 12) + self._id
    }

    if (self.barId == 1) then
        buttonIndexes[4] = 96 + self._id -- bear
        buttonIndexes[6] = 72 + self._id -- bear
        buttonIndexes[5] = 84 + self._id -- bear
    else
        buttonIndexes[4] = buttonIndexes[0]
        buttonIndexes[6] = buttonIndexes[0]
        buttonIndexes[5] = buttonIndexes[0]
    end

    local actionId = buttonIndexes[0]
    local type, id, actionMisc = GetActionInfo(actionId)

    if (type) then
        self.act_n = { type = type, id = id, actionId = actionId, actionMisc = actionMisc }
    else
        self.act_n = { type = 'empty', id = nil, actionId = actionId, actionMisc = actionMisc }
    end


    for k, v in pairs(buttonIndexes) do
        self:SetAttribute('tab_' .. k .. '_pnt', v)
    end

    for k, v in pairs(self.act_n) do
        self:SetAttribute('action_meta_' .. k, v)
    end

    self:SetAttribute('type', 'action')
    -- TODO: Figure out how to set correct shapeshift form initially
    self:SetAttribute('action', buttonIndexes[0])
end


--
-- DECLARE LIFECYCLE ACTIONS
--

-- type: spell, item,
-- id: [spell: numeric spell id] [item: 'item:..id' trigger string]
function d3ui_Button:UpdateBoundAction(tab, actionId, id, type, actionMisc)
    if (not type or not id) then
        if (type ~= 'summonmount') then
            --print('Warning: No action but button attempts to update bind')
            type = 'empty'
            id =  nil
            actionId = nil
            actionMisc = nil
        end
    end

    -- for some reason mount info isn't available from secure area, attempt to update it here
    if (type == 'summonmount') then
        type, id, actionMisc = GetActionInfo(actionId)
    end

    -- this is referrenced during lifecycle
    self.act_n = { type = type, id = id, actionId = actionId, actionMisc = actionMisc }
    self.tab = tab

    self:Update()
end

function d3ui_Button:ClearBoundAction()
    self:Update()
end

function d3ui_Button:OnEnter()
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT");
    local action = self.act_n
    Lookup.tooltip[self.act_n.type](self.act_n.id, self)

    if (self.hasGlow) then return end;
    self.overlay:SetAlpha(1)
    self.border:SetVertexColor(1, 1, 1, 1)

    if (self.bar.config.DISPLAY.MODEST) then
        self.bar.frame:SetAlpha(1)
    end
end

function d3ui_Button:OnLeave()
    GameTooltip_SetDefaultAnchor(GameTooltip, self);
    GameTooltip:Hide()

    if (self.hasGlow) then return end;
    self.overlay:SetAlpha(0)
    if (self.act_n and self.act_n.type ~= 'empty') then
        self.border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, 1)
    else
        self.border:SetAlpha(0)
    end

    if (self.bar.config.DISPLAY.MODEST) then
        self.bar.frame:SetAlpha(0)
    end
end

function d3ui_Button:SetElemAlpha(n)
    self.texture:SetAlpha(n)
    self.bindText:SetAlpha(n)
    self.chargesText:SetAlpha(n)
end

function d3ui_Button:Update()
    local action = self.act_n

    if (not action or action.type == 'empty') then
        self.border:SetAlpha(0)
        self.texture:SetTexture(nil)
        self.bindText:SetText(nil)
        self.chargesText:SetText(nil)

        return
    end

    if (not Lookup.icon[self.act_n.type]) then
        print(self.act_n.type)
    end

    local icon = Lookup.icon[self.act_n.type](self.act_n.id, "target")

    local currentCharges, maxCharges = Lookup.count[self.act_n.type](action.id)
    local count = GetSpellCount(action.id)
    self.hasCharges = (maxCharges and (maxCharges > 1)) or (count and count > 0)
    --print('....', self.hasCharges)
    self.border:SetAlpha(1)
    self.texture:SetTexture(icon)
    self.bindText:SetText(self.config.bind)
end

function d3ui_Button:UpdateInRange()
    if (not self.act_n or not self.act_n.id) then return end
    local inRange, b, c = Lookup.in_range[self.act_n.type](self.act_n.id, "target")

    if (inRange == nil) then
        self:SetElemAlpha(1)
        self.inRange = true
    else
        if (inRange == 1) then
            self:SetElemAlpha(1)
            self.inRange = true
            self.border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, 1)
        else
            self:SetElemAlpha(.5)
            self.inRange = false
            self.border:SetVertexColor(77 / 255, 38 / 255, 17 / 255, 1)
        end
    end
end

function d3ui_Button:UpdateEnoughResource()
    if (not self.act_n or not self.inRange) then return end
    local usable, noMana = Lookup.usable[self.act_n.type](self.act_n.id)

    if (usable) then
        self:SetElemAlpha(1)
        self.border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, 1)
    else
        self:SetElemAlpha(.5)
        if (noMana) then
            self.border:SetVertexColor(27 / 255, 31 / 255, 125 / 255, 1)
        else
            self.border:SetVertexColor(45 / 255, 45 / 255, 45 / 255, .7)
        end
    end
end

function d3ui_Button:UpdateGlow()
    if (self.hasGlow) then
        if (self.act_n.id and IsSpellOverlayed(self.act_n.id)) then
            self.overlay:SetTexture(CONSTS.TEXTURES.BTN_FLASH)
            self.border:SetVertexColor(245 / 255, 200 / 255, 82 / 255, 1)
            self.overlay:SetAlpha(1)
        else
            self.hasGlow = false
            self.overlay:SetAlpha(0)
            self.overlay:SetTexture(CONSTS.TEXTURES.BTN_OVERLAY)
            if (self.act_n) then
                self.border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, 1)
            else
                self.border:SetAlpha(0)
            end
        end
    end
end

function d3ui_Button:UpdateCharges()
    if (self.hasCharges) then
        local charges = 0
        if (self.act_n) then
            charges = Lookup.count[self.act_n.type](self.act_n.id)
            if (not charges) then
                charges = GetSpellCount(self.act_n.id)
            end
        else
            self.hasCharges = false
            self.chargesText:SetText('')
        end

        if (charges and charges > 0) then
            self.chargesText:SetText(charges)
        else
            self.chargesText:SetText('')
        end
    else
        self.chargesText:SetText('')
    end
end



function d3ui_Button:UpdateCooldown()
    if (not self.act_n) then return end

    if(not Lookup.cooldown[self.act_n.type]) then
       print(self.act_n.type)
    end

    local start, cooldownDuration = Lookup.cooldown[self.act_n.type](self.act_n.id)
    if (not cooldownDuration) then return end

    local _1, gcdDuration = GetSpellCooldown(61304)
    self.cooldown:SetCooldown(start, cooldownDuration)
    if (cooldownDuration > gcdDuration) then
        self.timer:SetTimer(start + cooldownDuration)
        self.onCooldown = true
    else
        if (gcdDuration > 0) then
            self.timer.frame:Hide()
            self.onCooldown = true
        else
            self.onCooldown = false
        end
    end
end

function d3ui_Button:AttachEvents()
    local btn = self
    local events = {}

    function events:SPELL_UPDATE_COOLDOWN()
        btn:UpdateCooldown()
    end

    function events:SPELL_ACTIVATION_OVERLAY_GLOW_SHOW(id)
        if (not btn.act_n) then return end;

        if (btn.act_n.id == id) then
            btn.hasGlow = true
            btn.border:SetVertexColor(245 / 255, 200 / 255, 82 / 255, 1)
            btn.overlay:SetTexture(CONSTS.TEXTURES.BTN_FLASH)
            btn.overlay:SetAlpha(1)
        end
    end

    UTIL:RegisterEvents(btn, events)

    btn:SetScript("OnUpdate", THROTTLER:Hook('update_btn_' .. btn:GetName(), function()
        btn:UpdateInRange()
        btn:UpdateEnoughResource()
        btn:UpdateGlow()
        btn:UpdateCharges()
        -- enable if cooldown weirds out
        --btn:UpdateCooldown()
    end))
end

function d3ui_Button:EnableInteractions()
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton", "RightButton")
    self:RegisterForClicks("AnyUp")
end

function d3ui_Button:AttachSecureHandlers() -- parent frame that wraps these
    self:SetScript("OnDragStart", nil)
    self:SetScript("OnReceiveDrag", nil)
    self:SetScript("OnEnter", nil)
    self:SetScript("OnLeave", nil)
    self:SetScript("PreClick", nil)
    self:SetScript("PostClick", nil)

    local tab = self.bar.frame:GetAttribute('tabref') or 0
    self.tab = tab

    self:SetAttribute('tabref', tab)
    -- handlers

    self:SetAttribute("UpdateActionAttrs", [[
        local actionId, id, type, actionMisc = ...
        self:SetAttribute('action_meta_actionId', actionId)
        self:SetAttribute('action_meta_id', id)
        self:SetAttribute('action_meta_type', type)
        self:SetAttribute('action_meta_actionMisc', actionMisc)
    ]])



    self:SetAttribute("AttemptBoundActionUpdate", [[
        local tab = self:GetAttribute('tabref')
        local actionId = self:GetAttribute('action')
        local type, id, actionMisc = GetActionInfo(actionId)
        local currentType = self:GetAttribute('action_meta_type')
        local currentId = self:GetAttribute('action_meta_id')
        if((id ~= currentId) or (type ~= currentType)) then
            self:RunAttribute("UpdateActionAttrs", actionId, id, type, actionMisc)
            self:CallMethod("UpdateBoundAction", tab, actionId, id, type, actionMisc)
        end
        self:SetAttribute('shouldUpdateOnDrag', false)
    ]])

    self:SetAttribute("ChangeTab", [[
        local tab = ...
		self:SetAttribute('tabref', tab)
		local actionId = self:GetAttribute('tab_'..tab..'_pnt') -- (newish)
        self:SetAttribute('action', actionId)

        local type, id, actionMisc = GetActionInfo(actionId)
        self:RunAttribute("UpdateActionAttrs", actionId, id, type, actionMisc)
        self:CallMethod("UpdateBoundAction", tab, actionId, id, type, actionMisc)
    ]])

    self:SetAttribute("OnEnter", [[ self:CallMethod("OnEnter") ]])
    self:SetAttribute("OnLeave", [[ self:CallMethod("OnLeave") ]])
    self:SetAttribute("OnDragStart", [[
        print('dragging from btn')

        return 'action', self:GetAttribute('action')
    ]], [[ print('post') ]])

    self:SetAttribute("OnReceiveDrag", [[  ]])

    self:SetAttribute("_childupdate-state", [[
		self:RunAttribute('ChangeTab', message)
	]])

    -- triggers
    self.bar.frame:WrapScript(self, "OnEnter", [[ return self:RunAttribute("OnEnter") ]])
    self.bar.frame:WrapScript(self, "OnLeave", [[ return self:RunAttribute("OnLeave") ]])
    self.bar.frame:WrapScript(self, "OnDragStart", [[ return self:RunAttribute("OnDragStart", kind, value, ...) ]])
    self.bar.frame:WrapScript(self, "OnReceiveDrag", [[ return self:RunAttribute("OnReceiveDrag", kind, value, ...) ]])

    self.bar.frame:WrapScript(self, "PostClick", [[
        return self:RunAttribute("AttemptBoundActionUpdate")
    ]])
end

function d3ui_Button:ApplyConfig(config)
    self.config = config

    if (config.hidden) then self:Hide() end

    if (config.tabs[self.tab]) then
        local tabConfig = deepcopy(config.tabs[self.tab])
        print(tabConfig.type)
        if (tabConfig.type ~= 'empty') then
            self:SetAttribute('type', 'action')
        else
            self:SetAttribute('type', 'empty')
        end
    end

    self:AttachEvents()

    self:Update()

    if (not InCombatLockdown()) then
        if (config.bind and ActionBarBindMap[config.bind]) then
            SetOverrideBindingClick(d3ui_Superframe, true, ActionBarBindMap[config.bind], self:GetName(), 'LeftButton')
        end
    else
        -- print('WARNING: Cant change binding in combat')
    end

    self:UpdateCooldown()
end


--
-- expose
--

function d3ui_ActionButtonCreate(barIndex, buttonIndex, bar)
    local barFrame = bar.frame

    local btn = setmetatable(CreateFrame("Button",
        'd3ui_ActionBar_' .. barIndex .. '_Btn_' .. buttonIndex,
        barFrame,
        "SecureActionButtonTemplate, ActionButtonTemplate"),
        d3ui_ButtonIndex -- provides available actions to button instance, actions can referrence self)))))
    )

    btn.bar = bar
    btn.barId = barIndex
    btn._id = buttonIndex
    btn.id = 0


    btn:SetUpMeta()
    btn:AddUIElements()
    btn:EnableInteractions()
    -- SESURITY STUFF
    btn:AttachSecureHandlers()
    btn:AttachSecureHandlers()


    return btn
end
