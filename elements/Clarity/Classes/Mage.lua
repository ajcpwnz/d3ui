CLARITY_CONFIGS[8] = { -- MAGE
    SPECS = {
        [2] = {

            [1] = ClarityTemplates:CombatUptime('Blazing Barrier', 'aura_ice_barrier', nil, 'S2'),
            [2] = ClarityTemplates:CombatCooldown('Combustion', 'S3'),
        },
        [3] = {
            [1] = ClarityTemplates:CombatUptime('Ice Barrier', 'aura_ice_barrier', nil, 'S2'),
            [2] = ClarityTemplates:CombatCooldown('Icy Veins', 'S3'),
        }
    },

    SHARED = {
        [1] = ClarityTemplates:AuraIcon('Arcane Intellect', 'aura_aracane'),
    }
}