local Class = require 'hump.class'
local Entity = require 'Entities.Base'

local Particle = Class{__includes = Entity}

function Particle:init(indicator, location, lifetime)
	Entity.init(self, indicator, location)
	self.lifeTimer = lifetime
end

function Particle:update(dt)
	self.lifeTimer = self.lifeTimer - dt
	if self.lifeTimer <= 0 then
		CombatArena:Despawn(self)
	end
end

return Particle
