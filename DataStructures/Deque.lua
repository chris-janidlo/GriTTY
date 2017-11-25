-- returns namespace of various deque-related data structures, each a hump class
-- contains: Deque.Stack, Deque.Queue, Deque.Deque
-- the first two have methods 'push' and 'pop' which work as expected. Deque.Deque has the methods 'pushleft,' 'pushright,' 'popleft,' and 'popright,' which are all self-explanatory. across all classes, return nil when attempting to pop when empty.

local Class = require 'hump.class'

---------- CORE ----------
-- modified from PiL first edition, 11.4

local function init(self)
	self.size = 0
	self.first = 0
	self.last = -1
end

local function pushleft(self, value)
	local first = self.first - 1
	self.first = first
	self[first] = value
	self.size = self.size + 1
end

local function pushright(self, value)
	local last = self.last + 1
	self.last = last
	self[last] = value
	self.size = self.size + 1
end

local function popleft(self)
	local first = self.first
	if first > self.last then return nil end
	local value = self[first]
	self[first] = nil        -- to allow garbage collection
	self.first = first + 1
	self.size = self.size - 1
	return value
end

local function popright(self)
	local last = self.last
	if self.first > last then return nil end
	local value = self[last]
	self[last] = nil         -- to allow garbage collection
	self.last = last - 1
	self.size = self.size - 1
	return value
end

---------- NAMESPACE ----------

local Deque = {
	Stack = Class {
		init = init,
		push = pushright,
		pop = popright
	},
	Queue = Class {
		init = init,
		push = pushright,
		pop = popleft
	},
	Deque = Class {
		init = init,
		pushleft = pushleft,
		pushright = pushright,
		popleft = popleft,
		popright = popright
	}
}

return Deque
