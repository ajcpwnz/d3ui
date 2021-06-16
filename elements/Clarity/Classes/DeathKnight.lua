CLARITY_CONFIGS[6] = { -- DRUID
    SPECS = {
        [1] = {
            [1] = ClarityTemplates:CombatCooldown('Vampiric Blood', 'S1'),
            [2] = ClarityTemplates:CombatCooldown('Rune Tap', 'S2'),
            [3] = ClarityTemplates:CombatCooldown('Anti-Magic Shell', 'S3'),
            [4] = ClarityTemplates:CombatCooldown('Swarming Mist', 'S4'),
            [5] = ClarityTemplates:CombatCooldown('Icebound Fortitude', 'Q'),
            [6] = ClarityTemplates:CombatCooldown('Lichborne', 'SQ'),

            [7] = ClarityTemplates:CombatCooldown('Mind Freeze', 'E', 'cc'),
            [8] = ClarityTemplates:CombatCooldown('Asphyxiate', 'SE', 'cc'),
            [9] = ClarityTemplates:CombatCooldown('Death Grip', 'SR', 'cc'),
            [10] = ClarityTemplates:CombatCooldown('Gorefiend\'s Grasp', 'M5', 'cc'),

            [11] = ClarityTemplates:CombatCooldown('Door of Shadows', 'M4', 'mobility'),
            [12] = ClarityTemplates:CombatCooldown('Death\'s Advance', '*', 'mobility'),
            [13] = ClarityTemplates:CombatCooldown('Wraith Walk', '*', 'mobility'),
            [14] =  ClarityTemplates:CombatStatusBar('Rune Tap', 'dk_runetap'),
            [15] =  ClarityTemplates:CombatStatusBar('Vampiric Blood', 'dk_vampiric'),
            [16] =  ClarityTemplates:CombatStatusBar('Icebound Fortitude', 'dk_icbf'),
            [17] =  ClarityTemplates:CombatStatusBar('Dancing Rune Weapon', 'dk_vewq'),
            [18] =  ClarityTemplates:CombatStatusBar('Lichborne', 'dk_Lich'),
        }
    },

    SHARED = {}
}