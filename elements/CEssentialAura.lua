local CEssentialAura = {}

local ICONS_PER_ROW = 6


function CEssentialAura:CreateFrames()
    local frame = CreateFrame('Frame', 'd3ui_EssentialAura_'..self.unit, self.parent)
    frame:SetAllPoints(self.parent)
    frame:SetFrameLevel(CONSTS.LAYERS.PLAYER_FRAME_ABSORB + 3) -- TODO: Handle levels someplace higher
    self.frame = frame
    local ICON_SIZE = self.frame:GetWidth() / ICONS_PER_ROW

    self.icons = {}
    for idx, aura in pairs(self.config) do
        local icon  = d3ui.AuraIcon:Load(aura.name, self.unit, {W = ICON_SIZE, H = ICON_SIZE}, self.frame)
        icon.frame:SetPoint('TOPLEFT', ICON_SIZE * (idx - 1), 0)

        self.icons[idx] = icon
    end

end


local classConfigs = {
    ['DRUID'] = {
        [4] = {
            [1] = {
                name = 'Rejuvenation'
            },
            [2] = {
                name = 'Lifebloom'
            },
            [3] = {
                name = 'Regrowth'
            },
            [4] = {
                name = 'Wild Growth'
            },
            [5] = {
                name = 'Spring Blossoms'
            },
            [6] = {
                name = 'Ironbark'
            }
        }
    }
}

function CEssentialAura:Construct(unit, parent)
    local class = UTIL:GetClassToken('player')
    local classConfig = classConfigs[class]
    local auraConfig = {}

    if(classConfig) then
        auraConfig = classConfig[GetSpecialization()]
    end

    local inst = { unit = unit, parent = parent, config = auraConfig or {} }
    
    setmetatable(inst, self)
    self.__index = self

    return inst
end

function CEssentialAura:AddEventHandlers()
    local inst = self 

    local unitEvents = {}

    function unitEvents:UNIT_AURA(unit)
        if(unit == inst.unit) then
            for _, icon in pairs(inst.icons) do
                icon:HandleChange()
            end
        end 
    end

    UTIL:RegisterEvents(inst.frame, {}, unitEvents, inst.unit)
end

local IEssentialAura = {}

function IEssentialAura:Load(unit, parent)
    local inst = CEssentialAura:Construct(unit, parent)
    inst:CreateFrames()
    inst:AddEventHandlers()
end

d3ui.EssentialAura = IEssentialAura