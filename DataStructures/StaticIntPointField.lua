-- view of IntPoint that guarantees, after a require, equality between any point calls
-- TODO: maybe add a function to return a zoomed in view?
local IntPoint = require 'DataStructures.IntPoint'

local StaticIntPointField = {}

-- set these to arbitrarily large values
StaticIntPointField.lower, StaticIntPointField.upper = -128, 128

for x = StaticIntPointField.lower,StaticIntPointField.upper do
	StaticIntPointField[x] = {}
	for y = StaticIntPointField.lower,StaticIntPointField.upper do
		StaticIntPointField[x][y] = IntPoint(x, y)
	end
end

function StaticIntPointField:__call(x, y)
	assert(x >= self.lower and x <= self.upper,
			'x value '..x..' is out of bounds ('..self.lower..', '..self.upper..')')
	assert(y >= self.lower and y <= self.upper,
			'y value '..y..' is out of bounds ('..self.lower..', '..self.upper..')')
	return self[x][y]
end

function StaticIntPointField.staticizePoint(point)
	return StaticIntPointField(point.x, point.y)
end

---------- MATH OPS ----------
-- these all just use IntPoint's operations, then index back on the field
function StaticIntPointField.__unm(point)
	return StaticIntPointField.staticizePoint(-point)
end

function StaticIntPointField.__add(a, b)
	return StaticIntPointField.staticizePoint(a + b)
end

function StaticIntPointField.__sub(a, b)
	return StaticIntPointField.staticizePoint(a - b)
end

function StaticIntPointField.__mul(a, b)
	return StaticIntPointField.staticizePoint(a * b)
end

function StaticIntPointField.__div(a, b)
	return StaticIntPointField.staticizePoint(a / b)
end

return setmetatable(StaticIntPointField, StaticIntPointField)
