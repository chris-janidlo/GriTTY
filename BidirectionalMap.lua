local Class = require 'hump.class'

local BidirectionalMap = Class{}

-- _variables are a Pythonic approach to "private" variables. They aren't restricted, but I'd really rather you didn't access them.
function BidirectionalMap:init()
	self._forward = {}
	self._backward = {}
end

function BidirectionalMap:get(val)
	return self._forward[val] or self._backward[val]
end

function BidirectionalMap:unset(val)
	fore, back = self._forward[val], self._backward[val]
	if fore then
		self._backward[fore] = nil
		self._forward[val] = nil
	end
	if back then
		self._forward[back] = nil
		self._backward[val] = nil
	end
end

function BidirectionalMap:set(val1, val2)
	-- ensure that this will be the unique pairing of val1 to anything and val2 to anything
	self:unset(val1)
	self:unset(val2)
	
	-- now pair them
	self._forward[val1] = val2
	self._backward[val2] = val1
end

function BidirectionalMap:iterator()
	return pairs(self._forward)
end

function BidirectionalMap:__tostring()
	out = '<BidirectionalMap: ['
	for val1, val2 in pairs(self._forward) do
		out = out..' ('..tostring(val1)..', '..tostring(val2)..')'
	end
	return out..' ]>'
end

return BidirectionalMap
