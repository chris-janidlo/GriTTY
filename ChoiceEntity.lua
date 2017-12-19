-- any kind of entity driven by a ChoiceTree

local Class = require 'hump.class'
local CombatEntity = require 'CombatEntity'
local UT = require 'Utilities'

local ChoiceEntity = Class{__includes = CombatEntity}

-- assumes tree is well-formed tree made exclusively of elements from ChoiceTree namespace
-- also assumes that each leaf's value is a valid action list
function ChoiceEntity:init(indicator, location, tree)
	CombatEntity.init(self, indicator, location)
	self.tree = tree
end

function ChoiceEntity:update(dt)
	if not self.acting then
		self:action(self.tree:evaluate(self))
	end
end

return ChoiceEntity
