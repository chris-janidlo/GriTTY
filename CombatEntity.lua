local Class = require 'hump.class'
local Timer = require 'hump.timer'

local CombatEntity = Class{}

CombatEntity.maxHealth = 100

function CombatEntity:init(indicator, parentState)
	self.indicator = indicator
	self.parentState = parentState
	self.health = maxHealth
	self.animating = false
	self.color = { 255, 255, 255, 255 }
end

function CombatEntity:getLocation()
	return self.parentState.entities:get(self)
end

function CombatEntity:setLocation(point)
	self.parentState.entities:set(point, self)
end

function CombatEntity:__tostring()
	return '<CombatEntity: '..self.indicator..'>'
end

-- hump.timer's wait function wrapper
function CombatEntity:action(actionList, ...)
	Timer.script(actionList(self))
end


return CombatEntity
