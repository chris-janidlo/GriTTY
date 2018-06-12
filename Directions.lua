local PointField = require 'DataStructures.StaticIntPointField'

local d = {}

local function assignSynonyms(synTable, parentTable)
	local t = parentTable or d
	for value,synonyms in pairs(synTable) do
		for i,v in ipairs(synonyms) do
			t[v] = value
		end
	end
end

-- primitives
d.up = PointField(0, -1)
d.left = PointField(-1, 0)
d.down = PointField(0, 1)
d.right = PointField(1, 0)

d.up_right = PointField(1, -1)
d.up_left = PointField(-1, -1)
d.down_left = PointField(-1, 1)
d.down_right = PointField(1, 1)

assignSynonyms({
	[d.up]			= {'w', 'north', 'top'},
	[d.left]		= {'a', 'west'},
	[d.down]		= {'s', 'south', 'bottom'},
	[d.right]		= {'d', 'east'},
	[d.up_right]	= {'e', 'north_east'},
	[d.up_left]		= {'q', 'north_west'},
	[d.down_left ]	= {'z', 'south_west'},
	[d.down_right]	= {'c', 'south_east'},
})

function d:IsCardinal(value)
	return value == self.w or value == self.a or value == self.s or value == self.d
end

-- defnes directions and indicators for things that happen in square rings around entities
d.Squares = {
	[1] = {
		indicators = {
			'\\', '|', '/',

			'-',       '-',
			
			'/',  '|', '\\'
		},
		vectors = {
			d.up_left, d.up, d.up_right, d.left, d.right, d.down_left, d.down, d.down_right
		}
	},
	[2] = {
		indicators = {
			'\\', '\\', '|',  '/',  '/',

			'\\',                   '/',

			'-',    --[[ o ]]       '-',

			'/',                   '\\',
			
			'/',  '/',  '|', '\\', '\\'
		},
		vectors = {
			d.up_left * 2,			-- \
			d.up + d.up_left,		-- \
			d.up * 2,				-- |
			d.up + d.up_right,		-- /
			d.up_right * 2,			-- /
			d.left + d.up_left,		-- \
			d.right + d.up_right,	-- /
			d.left * 2,				-- -
			d.right * 2,			-- -
			d.left + d.down_left,	-- /
			d.right + d.down_right,	-- \
			d.down_left * 2,		-- /
			d.down + d.down_left,	-- /
			d.down * 2,				-- |
			d.down + d.down_right,	-- \
			d.down_right * 2		-- \
		}
	}
}

return d
