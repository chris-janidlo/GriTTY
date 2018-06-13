local Class = require 'hump.class'
local CombatEntity = require 'CombatEntity'

local Particle = Class{__includes = CombatEntity}

function Particle:init(indicator, location, lifetime)
	CombatEntity.init(self, indicator, location)
	self.lifeTimer = lifetime
end

function Particle:update(dt)
	self.lifeTimer = self.lifeTimer - dt
	if self.lifeTimer <= 0 then
		CombatArena:Despawn(self)
	end
end

return Particle
