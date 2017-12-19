local Class = require 'hump.class'
local CombatEntity = require 'CombatEntity'
local Deque = require 'DataStructures.Deque'
local ColorDefinitions = require 'ColorDefinitions'

local PlayerEntity = Class{
	__includes = CombatEntity,
	actingColor = ColorDefinitions.playerActing;
}

function PlayerEntity:init(indicator, location)
	CombatEntity.init(self, indicator, location)

	----- actionQueue -----
	-- whenever this is not empty and the player is currently not acting, the least recent item will be popped and executed. PlayerEntity assumes each entry and its contents are well-formed.
	-- each entry has the following format:
	-- {name = <string>, action = <action table>, additionalArgs? = <array of strings>}
	self.actionQueue = Deque.Queue()
end

function PlayerEntity:update(dt)
	if self.actionQueue.size > 0 and not self.acting then
		local item = self.actionQueue:pop()
		self:action(item.cmd.action, unpack(item.args or {}))
	end
end

function PlayerEntity:pushAction(cmd, args)
	self.actionQueue:push({cmd=cmd, args=args})
end

return PlayerEntity
