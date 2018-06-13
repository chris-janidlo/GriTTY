local Class = require 'hump.class'
local Timer = require 'hump.timer'
local Terminal = require 'Gamestate.Terminal'

local Entity = Class{}

Entity.maxHealth = 100

function Entity:init(indicator, location)
	self.indicator = indicator
	self.currentIndicator = indicator
	self.location = location
	self.health = Entity.maxHealth
	self.color = { 255, 255, 255, 255 }
	self.acting = false
	self.invuln = false
	self.invulnPeriod = .5
	self.healthMod = 1
end

function Entity:ChangeHealth(deltaH)
	if self.invuln then return end
	
	for k,v in pairs(self) do
		print(tostring(k)..'\t'..tostring(v))
	end
	self.health = self.health + deltaH * self.healthMod
	self.invuln = true
	local blink = Timer.every(.13, function()
		if self.currentIndicator == '' then
			self.currentIndicator = self.indicator
		else
			self.currentIndicator = ''
		end
	end)
	Timer.after(self.invulnPeriod, function()
		self.invuln = false
		Timer.cancel(blink)
		self.currentIndicator = self.indicator
	end)
end

function Entity:deinit()
	-- to be overridden as necessary
end

-- (re)sets color
-- default: white, full alpha
function Entity:setColor(r, g, b, a)
	if type(r) == 'table' then
		self.color = r
	else
		self.color = {r or 255, g or 255, b or 255, a or 255}
	end
end

function Entity:setIndicator(newInd, permanent)
	if not permanent then
		self._tmpInd = self.currentIndicator
	end
	self.currentIndicator = newInd
end

function Entity:resetIndicator()
	if self._tmpInd then
		self.currentIndicator = self._tmpInd
		self._tmpInd = nil
	end
end

function Entity:__tostring()
	return '<Entity: '..self.currentIndicator..'>'
end

----- ACTION DOCSTRING -----
-- action must be a table with the following format:
--	{
--		{ action1, time1 },
--		{ action2, time2 },
--		...
--		{ actionN, timeN }
--	}
-- there can be any number of such pairs.
-- requirements:
--	 each pair needs to follow this exact order.
--	 none of these pairs should be labeled with anything except standard table-array labels, and the same goes for the values inside each pair table.
--	 each action must be a method, and each time must be a non-negative number.
-- for every pair, the action is called and passed self (the identity of the calling entity) and any additional arguments that were given to the outer 'action' function. then, the script waits for the associated time before continuing to the next action.
-- assumes that actionList is properly formatted and does NO ERROR HANDLING except to check if this entity is already in the middle of an action.
----- END DOCSTRING -----
function Entity:action(actionFun, ...)
	if self.acting then return end

	self.acting = true
	args = {...}
	Timer.script(function(wait)
		actionFun(Terminal.getActive(), self, wait, unpack(args)) -- unfortunately, can't pass ... without this silly workaround
		self.acting = false -- have to set this inside the coroutine in order to be accurate
	end)
end

return Entity
