local Class = require 'hump.class'

local buffer = Class{}

function buffer:init(size, oldBuffer)
	self.capacity = size
	if oldBuffer then
		self.size = oldBuffer.size
		self.buffer = oldBuffer.buffer
		self.debut, self.fin = oldBuffer.debut, oldBuffer.fin
	else
		self.size = 0
		self.buffer = {}
		self.debut, self.fin = 1, 0
	end
end

function buffer:add(object)
	self.buffer[self.fin + 1] = object
	self.fin = self.fin + 1
	self.size = math.min(self.size + 1, self.capacity)
	if self.size >= self.capacity then
		self.buffer[self.debut] = nil
		self.debut = self.debut + 1
	end
end

function buffer:lookBackward(index)
	assert(index >= 0, 'can\'t look negative backward')
	return self.buffer[self.fin - (index or 1)]
end

function buffer:iterator()
	local i = self.fin + 1
	return function()
		i = i - 1
		if i >= self.debut then return self.buffer[i] end
	end
end

return buffer
