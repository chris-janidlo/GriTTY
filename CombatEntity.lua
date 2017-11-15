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
end

-- (re)sets color
-- default: white, full alpha
function CombatEntity:setColor(r, g, b, a)
	self.color = {r or 255, g or 255, b or 255, a or 255}
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

return CombatEntity
