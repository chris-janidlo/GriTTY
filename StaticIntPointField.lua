-- view of IntPoint that guarantees, after initialization, equality between any point calls
-- usage: local PointField = require '<thisfilename>'; local field = PointField.new(<bounds>); local p, q = field(0,0), field(0,0); print(p == q)

local IntPoint = require 'IntPoint'

local StaticIntPointField = {}

function StaticIntPointField.new(lower_x, upper_x, lower_y, upper_y)
	field = {__call = function(self, x, y) return self[x][y] end}
	field.lower_x, field.upper_x, field.lower_y, field.upper_y = lower_x, upper_x, lower_y, upper_y
	for x = field.lower_x,field.upper_x do
		field[x] = {}
		for y = field.lower_y,field.upper_y do
			field[x][y] = IntPoint(x, y)
		end
	end
	return setmetatable(field, field)
end

return StaticIntPointField
