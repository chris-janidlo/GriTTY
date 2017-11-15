-- view of IntPoint that guarantees, after a require, equality between any point calls
-- TODO: add math ops here to replace weird manual casting
-- TODO: bounds checking here?
-- TODO: maybe add a function to return a zoomed in view?
local IntPoint = require 'IntPoint'

local StaticIntPointField = {__call = function(self, x, y) return self[x][y] end}

-- set these to arbitrarily large values
StaticIntPointField.lower, StaticIntPointField.upper = -128, 128

for x = StaticIntPointField.lower,StaticIntPointField.upper do
	StaticIntPointField[x] = {}
	for y = StaticIntPointField.lower,StaticIntPointField.upper do
		StaticIntPointField[x][y] = IntPoint(x, y)
	end
end

return setmetatable(StaticIntPointField, StaticIntPointField)
