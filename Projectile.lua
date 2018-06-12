local Class = require 'hump.class'
local CombatEntity = require 'CombatEntity'

local Projectile = Class{__includes = CombatEntity}

function Projectile:init(indicator, location, lifespan, damage)
	CombatEntity.init(self, indicator, location)
	self.lifeTimer = lifespan
	self.damage = damage or 0
end

-- don't override this
function Projectile:update(dt)
	local collision = CombatArena:GetFromMap('agents', self.location)
	if collision ~= nil then
		self:collide(collision)
		CombatArena:Despawn(self)
		return
	end
	self.lifeTimer = self.lifeTimer - dt
	if self.lifeTimer <= 0 then
		CombatArena:Despawn(self)
	end
end

-- can be overridden for sub behavior
function Projectile:collide(other)
	other:ChangeHealth(-self.damage)
end

return Projectile
