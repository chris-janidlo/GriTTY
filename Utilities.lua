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

return ut
