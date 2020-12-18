ContextMap = {}
ContextProvider = {}

function ContextMap:ExtractContext(field, index)
    local fieldContext = nil

    if(ContextMap[field]) then
        local fieldContextPointer = ContextMap[field]
        local tailContext = fieldContextPointer[index] or nil
        if(tailContext) then
            fieldContext = ContextProvider[tailContext]
        end
    end

    return fieldContext or {}
end


function SpawnCtx (defaultShard)
    local shard = defaultShard or 'shard_'..UTIL:RSTR(8)
    ContextProvider[shard] = {}

    return shard, ContextProvider[shard]
end


