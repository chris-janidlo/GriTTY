-- generic utilities that don't belong anywhere else

local ut = {}

-- returns new array that is the result of appending two integer-indexed arrays together
function ut.arrayConcat(array1, array2)
	local concat = {unpack(array1)}
	for i = 1,#array2 do
		table.insert(concat, array2[i])
	end
	return concat
end

function ut.clone (t) -- deep-copy a table
    if type(t) ~= "table" then return t end
    local meta = getmetatable(t)
    local target = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            target[k] = ut.clone(v)
        else
            target[k] = v
        end
    end
    setmetatable(target, meta)
    return target
end

return ut
