CONSTS = {
    ACTION_BARS = {
        BAR_LIMIT = 8,
        BUTTON_LIMIT = 12,
    },
    UI_TICKINTERVAL = 0.3333,
    UNIT_CONFIGS = {
        target = {
            X = 320,
            Y = -170,
            W = 198,
            H = 24,
            BAR_BACKDROP = "Interface\\AddOns\\d3ui\\inc\\Resources\\hp.blp",
            BAR_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-f.blp',
            ABSORB_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\absorb.blp',
            ROLE = 'target',
            SPECIALS = {
                level = true,
                reaction = true,
                auras = true
            },
        },
        targettarget = {
            X = 273,
            Y = -210,
            W = 99,
            H = 24,
            BAR_BACKDROP = "Interface\\AddOns\\d3ui\\inc\\Resources\\hp-bg-targettarget.blp",
            BAR_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-targettarget.blp',
            ABSORB_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\absorb-targettarget.blp',
            ROLE = 'targettarget',
            SPECIALS = {},
        },
        focus = {
            X = -320,
            Y = -170,
            W = 198,
            H = 24,
            BAR_BACKDROP = "Interface\\AddOns\\d3ui\\inc\\Resources\\hp.blp",
            BAR_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-f.blp',
            ABSORB_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\absorb.blp',
            ROLE = 'focus',
            SPECIALS = {
                level = true,
                reaction = true,
                auras = true
            },
        },
    },
    MAX_LVL = 60,
    COORDS = {
        HEALTH_FRAME_Y = -200,
    },
    LAYERS = {
        __BASE = 10,
        PLAYER_FRAME = 20,
        PLAYER_FRAME_HP = 21,
        PLAYER_FRAME_ABSORB = 22,
        POWER_BAR = 25,
        POINTS_POWER_BAR = 26
    },
    SIZES = {
        PARTY_MEMBER_FRAME = { W = 192, H = 24 },
        PLAYER_FRAME = { W = 198, H = 24 },
        POWER_BAR = { W = 128, H = 16 },
    },
    COLORS = {
        BASE = { r = 1, g = 1, b = 1 },
        PLAYER_FRAME = { r = 36 / 255, g = 155 / 255, b = 91 / 255 },
        PLAYER_FRAME_PREDICT = { r = 24 / 255, g = 118 / 255, b = 67 / 255 },
        FRIENDLY = { r = 36 / 255, g = 155 / 255, b = 91 / 255 },
        PROTECTED_ENEMY = { r = 255 / 255, g = 154 / 255, b = 98 / 255 },
        ENEMY = { r = 186 / 255, g = 28 / 255, b = 28 / 255 },
        DEBUFF = { r = 120 / 255, g = 9 / 255, b = 9 / 255 },
        BUFF = { r = 0 / 255, g = 67 / 255, b = 105 / 255 },
        PLAYER_FRAME_DANGER = { r = 236 / 255, g = 47 / 255, b = 138 / 255 },
        CASTBAR_NORMAL = { r = 235 / 255, g = 216 / 255, b = 43 / 255 },
        CASTBAR_NORMAL_CHANNEL = { r = 60 / 255, g = 217 / 255, b = 188 / 255 },
        CASTBAR_PROTECTED = { r = 214 / 255, g = 214 / 255, b = 214 / 255 },
        THREAT = {
            [0] = { r = 254 / 255, g = 199 / 255, b = 57 / 255, a = 0.5 },
            [1] = { r = 254 / 255, g = 199 / 255, b = 57 / 255, a = 0.75 },
            [2] = { r = 196 / 255, g = 30 / 255, b = 59 / 255, a = 0.5 },
            [3] = { r = 196 / 255, g = 30 / 255, b = 59 / 255, a = 0.75 },
        },
        RESOURCES = {
            ENERGY = { r = 255 / 255, g = 239 / 255, b = 100 / 255 },
            MANA = { r = 40 / 255, g = 37 / 255, b = 195 / 255 },
            LUNAR_POWER = { r = 113 / 255, g = 84 / 255, b = 228 / 255 },
            FOCUS = { r = 255 / 255, g = 184 / 255, b = 100 / 255 },
            RUNIC_POWER = { r = 84 / 255, g = 176 / 255, b = 228 / 255 },
            INSANITY = { r = 125 / 255, g = 32 / 255, b = 198 / 255 },
            FURY = { r = 198 / 255, g = 32 / 255, b = 181 / 255 },
            RAGE = { r = 198 / 255, g = 32 / 255, b = 42 / 255 },
            MAELSTROM = { r = 174 / 255, g = 105 / 255, b = 180 / 255 },
            --
            COMBO_POINTS = { r = 241 / 255, g = 84 / 255, b = 49 / 255 },
            ARCANE_CHARGES = { r = 7 / 255, g = 119 / 255, b = 251 / 255 },
            SOUL_SHARDS = { r = 124 / 255, g = 4 / 255, b = 181 / 255 },
            HOLY_POWER = { r = 255 / 255, g = 225 / 255, b = 67 / 255 },
            CHI = { r = 144 / 255, g = 237 / 255, b = 26 / 255 },
            ICICLES = { r = 73 / 255, g = 244 / 255, b = 255 / 255 },
            RUNE = { r = 196 / 255, g = 30 / 255, b = 59 / 255 },
            RUNE_RECHARGING = { r = 165 / 255, g = 140 / 255, b = 140 / 255 },
        },
        CLASSES = {
            DEFAULT = { r = 0, g = 0, b = 0 },
            WARRIOR = { r = 199 / 255, g = 156 / 255, b = 110 / 255 },
            WARLOCK = { r = 148 / 255, g = 130 / 255, b = 201 / 255 },
            SHAMAN = { r = 0 / 255, g = 112 / 255, b = 222 / 255 },
            ROGUE = { r = 255 / 255, g = 245 / 255, b = 105 / 255 },
            PRIEST = { r = 255 / 255, g = 255 / 255, b = 255 / 255 },
            PALADIN = { r = 245 / 255, g = 140 / 255, b = 186 / 255 },
            MONK = { r = 0 / 255, g = 255 / 255, b = 150 / 255 },
            MAGE = { r = 105 / 255, g = 204 / 255, b = 240 / 255 },
            HUNTER = { r = 171 / 255, g = 212 / 255, b = 115 / 255 },
            DRUID = { r = 255 / 255, g = 125 / 255, b = 10 / 255 },
            DEMONHUNTER = { r = 163 / 255, g = 48 / 255, b = 201 / 255 },
            DEATHKNIGHT = { r = 196 / 255, g = 30 / 255, b = 59 / 255 },
        },
    },
    TEXTURES = {
        TRANSPARENT = 'Interface\\AddOns\\d3ui\\inc\\transparent.blp',
        TARGET_INDICATOR = 'Interface\\AddOns\\d3ui\\inc\\target-indicator-texture.blp',
        TARGET_INDICATOR_BOSS = 'Interface\\AddOns\\d3ui\\inc\\target-indicator-texture-boss.blp',
        CLASS_INDICATOR = 'Interface\\AddOns\\d3ui\\inc\\class-indicator.blp',
        OVERLAY = 'Interface\\AddOns\\d3ui\\inc\\overlay.blp',
        BTN_OVERLAY = 'Interface\\AddOns\\d3ui\\inc\\btn-overlay.blp',
        BTN_FLASH = 'Interface\\AddOns\\d3ui\\inc\\btn-flash.blp',
        HP_BAR = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-f.blp',
        ABSORB = 'Interface\\AddOns\\d3ui\\inc\\Resources\\absorb.blp',
        HEAL_PREDICT = 'Interface\\AddOns\\d3ui\\inc\\inc_heal.blp',
        HP_BACKDROP = "Interface\\AddOns\\d3ui\\inc\\Resources\\hp.blp",
        POWER_BAR = 'Interface\\AddOns\\d3ui\\inc\\Resources\\power.blp',
        POWER_BAR_GRADIENT = 'Interface\\AddOns\\d3ui\\inc\\Resources\\power.blp',
        POWER_BACKDROP = "Interface\\AddOns\\d3ui\\inc\\Resources\\power-bg.blp",
        POWER_BACKDROP_STALE = "Interface\\AddOns\\d3ui\\inc\\Resources\\power-bg-stale.blp",
        COMBO = 'Interface\\AddOns\\d3ui\\inc\\Resources\\combo-f.blp',
        COMBO_STALE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\combo-stale.blp',
        CASTBAR_BACKDROP = 'Interface\\AddOns\\d3ui\\inc\\castbar-bg.blp',
        CASTBAR = 'Interface\\AddOns\\d3ui\\inc\\castbar.blp',
        STATUSBAR = 'Interface\\AddOns\\d3ui\\inc\\statusBar.blp',
        STATUSBAR_BACKDROP = 'Interface\\AddOns\\d3ui\\inc\\statusBar-bg.blp',
        CHEVRON_RIGHT_W = 'Interface\\AddOns\\d3ui\\inc\\chevron-right-w.blp',
        BORDER_SOLID = 'Interface\\AddOns\\d3ui\\inc\\border-solid-2.blp',
        BORDER_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\border-texture.blp',
        THREAT_BG = 'Interface\\AddOns\\d3ui\\inc\\threat-bg.blp',
        BAR_PLAIN = 'Interface\\AddOns\\d3ui\\inc\\bar-plain.blp',
        ROLES = 'Interface\\AddOns\\d3ui\\inc\\roles.blp',
        BTN_BACKGROUND= 'Interface\\AddOns\\d3ui\\inc\\btn-b.blp',
    },
    FONTS = {
        BASE = "Interface\\AddOns\\d3ui\\inc\\Fonts\\Ruda-SemiBold.ttf"
    },
    ROLE_TEX_COORDS = {
        TANK = { l = 0, r = 1, t = 0, b = 0.25 },
        HEALER = { l = 0, r = 1, t = 0.25, b = 0.5 },
        DAMAGER = { l = 0, r = 1, t = 0.5, b = 0.75 },
    }
}




local partyX = 1
local partyH = 36;
local partyW = partyH * 2.25;
local raidW = partyH * 2.25;
local raidH = partyH

for unit = 1,4 do
    CONSTS.UNIT_CONFIGS['party' .. unit] = {
        X = -11 + (partyW * (unit - 1)),
        Y = -45,
        POINT = "TOPLEFT",
        W = partyW,
        H = partyH,
        BAR_BACKDROP = "Interface\\AddOns\\d3ui\\inc\\Resources\\hp-bg-raid.blp",
        BAR_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-party.blp',
        BAR_TEXTURE_HOVER = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-party-hover.blp',
        ABSORB_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\party-absorb.blp',
        ROLE = 'party',
        SPECIALS = {essential_aura = true},
    }
end

for group = 1, 8 do
    for unit = 1, 5 do
        local unitIdx = ((group - 1) * 5) + unit
        CONSTS.UNIT_CONFIGS['raid' .. unitIdx] = {
            X = -51 + (raidW * (unit - 1)),
            Y = -45  -raidH * (group - 1),
            POINT = "TOPLEFT",
            W = raidW,
            H = raidH,
            BAR_BACKDROP = "Interface\\AddOns\\d3ui\\inc\\Resources\\hp-bg-raid.blp",
            BAR_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-party.blp',
            BAR_TEXTURE_HOVER = 'Interface\\AddOns\\d3ui\\inc\\Resources\\hp-party-hover.blp',
            ABSORB_TEXTURE = 'Interface\\AddOns\\d3ui\\inc\\Resources\\party-absorb.blp',
            ROLE = 'raid',
            SPECIALS = {essential_aura = true},
        }
    end
end
