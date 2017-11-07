local GameObject = {}

-- for every table that has f defined as a function, call f and pass on any additional arguments
function GameObject:CallAll(f, ...)
	for _,ent in ipairs(self) do
		if ent[f] then ent[f](ent,...) end
	end
end

function GameObject:Register(object)
	table.insert(GameObject, object)
end

return GameObject
