-- decision tree with some behavior tree functionality
local CT = {}

function CT.setDebug(value)
	CT.debug = value or true
end

local function debugPrint(node)
	if CT.debug then
		print('evaluating node of type "'..node.type..'"')
	end
end


---------- LEAF NODES ----------
-- nodes without children

-- basic leaf that simply takes a value on construction and returns that value on evaluation
CT.Leaf = function(value)
	return {
		type = 'leaf',
		value = value,
		evaluate = function(self, ...)
			debugPrint(self)
			return self.value
		end
	}
end


---------- COMPOSITE NODES ----------
-- nodes with children where the result of evaluation is based on the results of the children in some manner

-- node with single node as child, that simply returns evaluation of child
-- not necessary to make a correct tree, but can make things more readable by making it clear that this is a tree
-- should be called like CT.Root{node} to match style of other composite nodes, but can be called like CT.Root(node)
CT.Root = function(node)
	local function parseOutTable()
		-- first option: called like CT.Root{node}
		-- second: called like CT.Root(node)
		return node[1] or node
	end
	return {
		type = 'root',
		child = parseOutTable(),
		evaluate = function(self, ...)
			debugPrint(self)
			return self.child:evaluate(...)
		end
	}
end

-- chooses a single child to evaluate based on a function and an enumeration of that function's return values
-- named table as argument, with values:
	-- query: function. the return value of this is used to determine which option to use. 
	-- options: table. if query returns a key that is in this table, the associated value is evaluated, and that is returned. otherwise, options[self.defaultString] is evaluated
	-- defaultString: optional string. if present, changes where to look if query returns a value that is not a key in options. by default, this is set to 'base'
-- example:
--	node = CT.Select {
--		query = function(value) return value * 10 end,
--		options = {
--			[10] = 'hello',
--			[20] = 'world',
--			[50] = 50,
--			base = 'this is the default option'
--		}
--	}
-- with a non-default default:
--	node2 = CT.Select {
--		query = function() end,
--		defaultString = 'default',
--		options = {
--			base = 'this will never be returned',
--			default = 'this will always be returned'
--		}
--	}
CT.Select = function(table)
	return {
		type = 'choose',
		query = table.query,
		options = table.options,
		defaultString = table.defaultString or 'base',
		evaluate = function(self, ...)
			debugPrint(self)
			local node = self.options[self.query(...)] or self.options[self.defaultString]
			return node:evaluate(...)
		end
	}
end

-- array of nodes evaluated individually in sequence
-- returns multiple values (the evaluations, in order)
CT.Sequence = function(array)
	return {
		type = 'sequence',
		array = array,
		evaluate = function(self, ...)
			debugPrint(self)
			local children = {}
			for i,node in ipairs(self.array) do
				-- in case we have any sub-sequences:
				local vals = {node:evaluate(...)}
				for j,val in ipairs(vals) do
					table.insert(children, val)
				end
			end
			return unpack(children)
		end
	}
end

-- array of nodes; choose one child at random and return its evaluation
CT.Random = function(array)
	return {
		type = 'random',
		array = array,
		evaluate = function(self, ...)
			debugPrint(self)
			return self.array[math.random(#self.array)] :evaluate(...)
		end
	}
end

return CT
