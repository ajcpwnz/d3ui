CLARITY_CONFIGS[11] = { -- DRUID
    SPECS = {
        [1] = {
            [1] = ClarityTemplates:CombatCooldown('Incarnation: Chosen of Elune', 'S4'),
            [2] = ClarityTemplates:AuraIcon('Moonkin Form', 'stance_moonkin', nil, nil, true),
            [3] = ClarityTemplates:AuraIcon('Lone Spirit', 'kyrian_shit', nil, 'Kindred Spirits', true),
            [4] = ClarityTemplates:CombatCooldown('Solar Beam', 'E', 'cc'),
            [5] = ClarityTemplates:CombatCooldown('Typhoon', 'S2', 'cc'),
            [6] = ClarityTemplates:CombatCooldown('Incapacitating Roar', 'S3', 'cc'),
            [7] = ClarityTemplates:CombatCooldown('Barkskin', 'M4', 'mobility'),
            [8] = ClarityTemplates:CombatCooldown('Lone Empowerment', 'S1'),
            [9] = ClarityTemplates:CombatCooldown('Tiger Dash', 'SR', 'mobility'),
            [10] = ClarityTemplates:CombatCooldown('Mighty Bash', 'Q', 'cc'),

            [11] = ClarityTemplates:CombatStatusBar('Regrowth', 'druid_kyrian'),
            [12] = ClarityTemplates:CombatStatusBar('Barkskin', 'druidelp'),
            [13] = ClarityTemplates:CombatStatusBar('Incarnation: Chosen of Elune', 'druidedlp'),
            [15] = ClarityTemplates:CombatStatusBar('Lone Empowerment', 'druidedldp'),
            [14] = ClarityTemplates:CombatStatusBar('Starfall', 'starfall'),
        },
    },

    SHARED = {}
}