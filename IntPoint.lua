local Class = require 'hump.class'

local IntPoint = Class{}

local function assertIntegers(...)
	for _, n in ipairs{...} do
		assert(n==math.floor(n), 'non-integer operation on IntPoint')
	end
end

function IntPoint:init(x, y, alreadyChecked)
	if not alreadyChecked then assertIntegers(x, y) end
	self.x = x or 0
	self.y = y or 0
end

function IntPoint:__tostring()
	return '<IntPoint: '..self.x..', '..self.y..'>'
end

function IntPoint.__eq(lhs, rhs)
	return lhs.x == rhs.x and lhs.y == rhs.y
end

function IntPoint.__add(lhs, rhs)
	if getmetatable(lhs) == IntPoint and getmetatable(rhs) == IntPoint then
		return IntPoint(lhs.x + rhs.x, lhs.y + rhs.y)

	elseif type(lhs) == 'number' then
		assertIntegers(lhs)
		return IntPoint(rhs.x + lhs, rhs.y + lhs, true)
	elseif type(rhs) == 'number' then
		assertIntegers(rhs)
		return IntPoint(lhs.x + rhs, lhs.y + rhs, true)
	
	else
		error('can only add scalars or other IntPoints to an IntPoint')
	end
end

return IntPoint
