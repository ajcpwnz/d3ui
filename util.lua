CreateFrame("Frame", 'd3ui_InvisibleFrame', UIParent)

d3ui_InvisibleFrame:SetSize(1,1)
d3ui_InvisibleFrame:SetPoint("BOTTOM", -1, -1)
d3ui_InvisibleFrame:Hide()

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end


UTIL = {}

function UTIL:RegisterEvents (frame, events, unitEvents, target)
    frame:SetScript("OnEvent", function(self, event, ...)
        local handler = events[event] or unitEvents[event]
        handler(self, ...);
    end);

    for k, v in pairs(events) do frame:RegisterEvent(k); end
    for k, v in pairs(unitEvents or {}) do frame:RegisterUnitEvent(k, target or 'player'); end
end

function UTIL:FormatNumber(number)
      local found
      while( true ) do
          number, found = string.gsub(number, "^(-?%d+)(%d%d%d)", "%1,%2")
          if( found == 0 ) then break end
      end

      return number
  end


local Suffixes={[0]="","k","m","b"};
function UTIL:FormatHP(val)
 local exp=math.max(math.floor(math.log10(math.abs(val))),0);
 local factor=math.min(math.floor(exp/3),#Suffixes);
 if(val < 1000000) then
    return UTIL:FormatNumber(val)
 else
   return ("%."..(exp==factor*3 and 1 or 0).."f%s"):format(val/(1000^factor),Suffixes[factor]);
 end
end


function UTIL:AuraIterator(onMatch, onEmpty, query, target)
    for idx = 1,40 do
        local name, icon, count, debuffType,  duration, expirationTime, source, isStealable, nameplateShowPersonal  = UnitAura(target, idx, query)
        if(name) then
            onMatch(idx, name, icon, count, debuffType,  duration, expirationTime, source, isStealable, nameplateShowPersonal   )
        else
            break;
        end
    end
end

function UTIL:AddText(frame)
    local textNode = frame:CreateFontString(nil, "ARTWORK")
    textNode:SetFont(CONSTS.FONTS.BASE, 11, "")
    textNode:SetShadowOffset(1,-1)
    textNode:SetShadowColor(0,0,0,.8)
    textNode:SetTextColor(.95,.95,.95,1)

    if(frame.overrideColor) then
        textNode:SetColor(frame.overrideColor.r, frame.overrideColor.g, frame.overrideColor.b, 1)
    end

    return textNode
end

local charset = {}
-- qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890
for i = 48,  57 do table.insert(charset, string.char(i)) end
for i = 65,  90 do table.insert(charset, string.char(i)) end
for i = 97, 122 do table.insert(charset, string.char(i)) end

function UTIL:RSTR(length)
    local res = ""
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end


THROTTLER = {}

function THROTTLER:Hook(descriptor, handler, interval)
    THROTTLER[descriptor] = 0
    return function(_, elapsed)
        THROTTLER[descriptor] = THROTTLER[descriptor] + elapsed
        if(THROTTLER[descriptor] > (interval or CONSTS.UI_TICKINTERVAL)) then
            handler(_, elapsed)
        end
    end
end

function UTIL:Round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function UTIL:SecondsToTime(origSeconds, plain)
    local plain = plain or false
    local seconds = UTIL:Round(origSeconds)

    local label = seconds
    local postfix = ''
    if(not plain) then postfix = ' s' end

    if(seconds < 60) then
        if(seconds < 1) then
            label = '<1'
        end

        return label..postfix
    end

    if(seconds < 180) then
        local minutes = math.floor(seconds/60)
        local remainder = seconds - (minutes * 60)

        label = minutes..':'..(remainder > 9 and remainder or '0'..remainder)
        if(not plain) then postfix = ' m' end

        return label..postfix
    end

    if(seconds < 3600) then
        label = UTIL:Round(seconds/60)
        if(not plain) then postfix = ' m' end

        return label..postfix
    end

    if(seconds < 86400) then
        label = UTIL:Round(seconds/3600)
        if(not plain) then postfix = ' h' end

        return label..postfix
    end

    return label..postfix
end

function deepcopy(orig)
    local orig_type = type(orig)

    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function callIfCallable(f)
    return function(...)
        error, result = pcall(f, ...)
        if error then -- f exists and is callable
            print('ok')
            return result
        end
        -- nothing to do, as though not called, or print('error', result)
    end
end