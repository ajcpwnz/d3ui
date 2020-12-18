CPartyFrame = {}

function CPartyFrame:CreateFrame()
    self.frame = CreateFrame('Frame', 'd3ui_PartyFrame', d3ui_Superframe, BackdropTemplateMixin and "BackdropTemplate")
    self.frame:SetSize(336, 284)
    self.frame:SetPoint("BOTTOM", 0, 20)
    self.frame:Show()
end

function CPartyFrame:AddNestedFrames()
    for i = 1, 4 do
        self['frame' .. i] = d3ui.CUnitFrame:Load('party' .. i, self.frame, 'party' .. i)
    end
end

function CPartyFrame:AddRaidFrames()
    for partyIndex = 1, 8 do
        for i = 1, 5 do
            local index = ((partyIndex - 1) * 5) + i
            self['frame' .. index] = d3ui.CUnitFrame:Load('raid' .. index, self.frame, 'raid' .. index)
        end
    end
end

function CPartyFrame:AddEventHandlers()
    local inst = self
    local events = {}

    function events:GROUP_ROSTER_UPDATE()
        for i = 1, 4 do
            inst['frame' .. i]:HandleChange()
        end
    end

    UTIL:RegisterEvents(self.frame, events)
end

function CPartyFrame:AddRaidEventHandlers()
    local inst = self
    local events = {}

    function events:GROUP_ROSTER_UPDATE()
        for i = 1, 40 do
            inst['frame' .. i]:HandleChange()
        end
    end

    UTIL:RegisterEvents(self.frame, events)
end

function CPartyFrame:Load(unit)
    CPartyFrame:CreateFrame()
    if (IsInRaid()) then
        CPartyFrame:AddRaidFrames()
        CPartyFrame:AddRaidEventHandlers()
    else
        CPartyFrame:AddNestedFrames()
        CPartyFrame:AddEventHandlers()
    end
end



d3ui.PartyFrame = CPartyFrame