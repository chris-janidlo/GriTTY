local Class = require 'hump.class'
local Timer = require 'hump.timer'
local Signal = require 'hump.signal'
local CombatEntity = require 'CombatEntity'

local CombatAgent = Class{__includes = CombatEntity}

function CombatAgent:init(indicator, location)
	CombatEntity.init(self, indicator, location)
	self.acting = false
	self.invuln = false
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
function CombatAgent:action(actionList, ...)
	if self.acting then
		Signal.emit('tty_stderr', 'player agent is already executing an action')
		return
	end

	self.acting = true
	args = {...}
	Timer.script(function(wait)
		for i, action in ipairs(actionList) do
			action[1](self, unpack(args)) -- unfortunately, can't pass ... without this silly workaround
			wait(action[2])
		end
		self.acting = false -- have to set this inside the coroutine in order to be accurate
	end)
end

return CombatAgent
