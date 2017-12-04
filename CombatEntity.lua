local Class = require 'hump.class'
local Timer = require 'hump.timer'
local Signal = require 'hump.signal'

local CombatEntity = Class{}

CombatEntity.maxHealth = 100

function CombatEntity:init(indicator, location)
	self.indicator = indicator
	self.location = location
	self.health = maxHealth
	self.color = { 255, 255, 255, 255 }
	self.acting = false
	self.invuln = false
end

-- (re)sets color
-- default: white, full alpha
function CombatEntity:setColor(r, g, b, a)
	if type(r) == 'table' then
		self.color = r
	else
		self.color = {r or 255, g or 255, b or 255, a or 255}
	end
end

function CombatEntity:setIndicator(newInd, permanent)
	if not permanent then
		self._tmpInd = self.indicator
	end
	self.indicator = newInd
end

function CombatEntity:resetIndicator()
	if self._tmpInd then
		self.indicator = self._tmpInd
		self._tmpInd = nil
	end
end

function CombatEntity:__tostring()
	return '<CombatEntity: '..self.indicator..'>'
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
function CombatEntity:action(actionFun, ...)
	if self.acting then return end

	self.acting = true
	args = {...}
	Timer.script(function(wait)
		actionFun(wait, self, unpack(args)) -- unfortunately, can't pass ... without this silly workaround
		self.acting = false -- have to set this inside the coroutine in order to be accurate
	end)
end

return CombatEntity
