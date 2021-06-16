CPartyFrame = {}

local deb_unit = nil

function CPartyFrame:CreateFrame()
    self.frame = CreateFrame('Frame', 'd3ui_PartyFrame', d3ui_Superframe, BackdropTemplateMixin and "BackdropTemplate")
    self.frame:SetSize(300, 284)
    self.frame:SetPoint("BOTTOM", 0, 0)
    self.frame:Show()

    self.partyFrame = CreateFrame('Frame', 'd3ui_PartyPartyFrame', d3ui_InvisibleFrame, BackdropTemplateMixin and "BackdropTemplate")
    self.partyFrame:SetSize(300, 284)
    self.partyFrame:SetPoint("BOTTOM", 0, 55)
    self.partyFrame:Show()

    self.raidFrame = CreateFrame('Frame', 'd3ui_PartyRaidFrame', d3ui_InvisibleFrame, BackdropTemplateMixin and "BackdropTemplate")
    self.raidFrame:SetSize(300, 284)
    self.raidFrame:SetPoint("BOTTOM", 0, 55)
    self.raidFrame:Show()
end

function CPartyFrame:AddNestedFrames()
    for i = 1, 4 do
        self['party' .. i] = d3ui.CUnitFrame:Load(deb_unit or 'party' .. i, self.partyFrame, 'party' .. i)
    end
end 

function CPartyFrame:AddRaidFrames()
    for partyIndex = 1, 8 do
        for i = 1, 5 do
            local index = ((partyIndex - 1) * 5) + i
            self['raid' .. index] = d3ui.CUnitFrame:Load('raid' .. index, self.raidFrame, 'raid' .. index)
        end
    end
end


function CPartyFrame:HandleChange()
    local inst = self

    if(IsInRaid()) then 
        inst.raidFrame:SetParent(inst.frame)
        inst.partyFrame:SetParent(d3ui_InvisibleFrame)
        for i = 1, 40 do
            inst['raid' .. i]:HandleChange()
        end
    else
        inst.raidFrame:SetParent(d3ui_InvisibleFrame)
        if( IsInGroup()  or deb_unit) then 
            inst.partyFrame:SetParent(inst.frame)
            for i = 1, 4 do
                inst['party' .. i]:HandleChange()
            end
        else
            inst.partyFrame:SetParent(d3ui_InvisibleFrame)
        end
    end
end

function CPartyFrame:AddEventHandlers()
    local inst = self
    local events = {}

    function events:GROUP_ROSTER_UPDATE()
        inst:HandleChange()
    end

    UTIL:RegisterEvents(self.frame, events)
end


function CPartyFrame:Load(unit)
    CPartyFrame:CreateFrame()
    CPartyFrame:AddRaidFrames()
    CPartyFrame:AddNestedFrames()
    CPartyFrame:AddEventHandlers()
    CPartyFrame:HandleChange()
end



d3ui.PartyFrame = CPartyFrame