IStanceBar = {
    buttons = {},
    show = false,
    stances = 0,
};

LiteBtn = {};

local BTN_SIZE = 20

local keys = {
    [1] = 'ALT-CTRL-1',
    [2] = 'ALT-CTRL-2',
    [3] = 'ALT-CTRL-3',
    [4] = 'ALT-CTRL-E',
    [5] = 'ALT-CTRL-5',
}

function LiteBtn:Load(parent, idx)
    local icon, active, castable, spellID = GetShapeshiftFormInfo(idx);

    local btn = CreateFrame("CheckButton", 'd3ui_StanceBarButton'..idx, parent, 'StanceButtonTemplate');

    btn:SetID(idx)

    btn.Border:Hide()
    btn.NormalTexture:SetTexture(nil)
    btn:SetNormalTexture(nil)

    btn:EnableMouse(true)
    btn:RegisterForClicks('AnyUp')

    btn:SetSize(BTN_SIZE,BTN_SIZE)

    local border = btn:CreateTexture(nil, "OVERLAY")
    border:SetAllPoints(btn)
    border:SetTexture(CONSTS.TEXTURES.BORDER_TEXTURE)
    --    border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, 1)
    border:SetVertexColor(40 / 255, 40 / 255, 40 / 255, .8)
    border:SetAlpha(1)
    self.border = border

    local background = btn:CreateTexture(nil, "BACKGROUND")
    background:SetPoint('TOPLEFT', 0,0)
    background:SetPoint('BOTTOMRIGHT', 0,0)
    background:SetTexture(CONSTS.TEXTURES.BTN_BACKGROUND)
    self.background = background

    local texture = btn:CreateTexture(nil, "ARTWORK")
    texture:SetPoint('TOPLEFT', 2, -2)
    texture:SetPoint('BOTTOMRIGHT', -2, 2)
    texture:SetTexCoord(0.1, .9, 0.1, .9)
    self.texture = texture

    local overlay = btn:CreateTexture(nil, "OVERLAY")
    overlay:SetPoint('TOPLEFT', 2, -2)
    overlay:SetPoint('BOTTOMRIGHT', -2, 2)
    overlay:SetAlpha(0)
    overlay:SetTexture(CONSTS.TEXTURES.BTN_OVERLAY)
    self.overlay = overlay

    local bindText = btn:CreateFontString(nil, "OVERLAY")
    bindText:SetPoint("TOPRIGHT", -2, 2)
    bindText:SetFont(CONSTS.FONTS.BASE, 10, "OUTLINE")
    self.bindText = bindText

    self.texture:SetTexture(icon);

    btn:SetPoint('LEFT', (BTN_SIZE + 4) * (idx - 1), 0);

    SetBinding(keys[idx], "SHAPESHIFTBUTTON"..idx);
    SetOverrideBindingClick(parent, false, keys[idx], 'd3ui_StanceBarButton'..idx)

    btn:Show()

    return btn
end

function IStanceBar:CreateBar()
    local outer = CreateFrame("Button", 'd3ui_StanceBar', d3ui_Superframe, BackdropTemplateMixin and "BackdropTemplate")

    outer:EnableMouse(true)
    outer:RegisterForClicks('AnyUp')

    outer:Show();
    outer:SetPoint('BOTTOM', -196, 368);

    outer:SetSize((BTN_SIZE + 4) * 5, BTN_SIZE);

    self.outer = outer;
end


function IStanceBar:CreateButtons()
    self.stances = GetNumShapeshiftForms();

    if(self.stances == 0) then
        self.buttons = {}
        self.outer:Hide()
    else
        ClearOverrideBindings(self.outer)
        for idx = 1, self.stances do
            self.buttons[idx] =  LiteBtn:Load(self.outer, idx);
        end
    end
end

function IStanceBar:Load()
    self:CreateBar()
    self:CreateButtons()
end
