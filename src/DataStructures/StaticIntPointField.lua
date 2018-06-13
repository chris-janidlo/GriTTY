-- immutable vector of integers, such that any two calls of the same values will return the same table
-- TODO: maybe add a function to return a zoomed in view?

local StaticIntPointField = {}

-- set these to arbitrarily large values
StaticIntPointField.lower, StaticIntPointField.upper = -128, 128

for x = StaticIntPointField.lower,StaticIntPointField.upper do
	StaticIntPointField[x] = {}
	for y = StaticIntPointField.lower,StaticIntPointField.upper do
		StaticIntPointField[x][y] = setmetatable({x=x, y=y}, StaticIntPointField)
	end
end

local function isInt(number)
	return type(number) == 'number' and number==math.floor(number)
end

local function isVector(point)
	return type(point) == 'table' and type(point.x) == 'number' and type(point.y) == 'number'
end

function StaticIntPointField:assertions(fieldName, val)
	-- integer check
	assert(isInt(val), fieldName..' value '..val..' is not an integer')
	-- bounds check
	assert(val >= self.lower and val <= self.upper,
		fieldName..' value '..val..' is out of bounds ('..self.lower..', '..self.upper..')')
end

function StaticIntPointField:__call(x, y)
	self:assertions('x', x)
	self:assertions('y', y)
	return self[x][y]
end

---------- MATH OPS ----------
function StaticIntPointField.__unm(point)
	return StaticIntPointField(-point.x, -point.y)
end

function StaticIntPointField.__add(lhs, rhs)
	assert(isVector(lhs) and isVector(rhs), 'can only add IntPoints to other IntPoints')
	return StaticIntPointField(lhs.x + rhs.x, lhs.y + rhs.y)
end

function StaticIntPointField.__sub(lhs, rhs)
	assert(isVector(lhs) and isVector(rhs), 'can only sub IntPoints from other IntPoints')
	return lhs + -rhs
end

function StaticIntPointField.__mul(lhs, rhs)
	if isInt(lhs) then
		return StaticIntPointField(lhs * rhs.x, lhs * rhs.y)
	elseif isInt(rhs) then
		return StaticIntPointField(rhs * lhs.x, rhs * lhs.y)
	else
		assert(isVector(lhs) and isVector(rhs), "can only multiply IntPoints with numbers or each other")
		return (lhs.x * rhs.x) + (lhs.y * rhs.y)
	end
end

function StaticIntPointField.__div(lhs, rhs)
	assert(isVector(lhs) and isInt(rhs), "can only divide IntPoints by numbers")
	return StaticIntPointField(lhs.x / rhs, lhs.y / rhs)
end

return setmetatable(StaticIntPointField, StaticIntPointField)
