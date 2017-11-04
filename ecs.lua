local Entities = {} -- this is where entities go

-- for every table that has f defined as a function, call f and pass on any additional arguments
function Entities.CallAll(f, ...)
	for _,ent in ipairs(Entities) do
		if ent[f] then ent[f](ent,...) end
	end
end

return Entities
