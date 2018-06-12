local Class = require 'hump.class'
local CombatEntity = require 'CombatEntity'

local Projectile = Class{__includes = CombatEntity}

function Projectile:init(indicator, location, projectileParameters)
	CombatEntity.init(self, indicator, location)
	self.lifeTimer = projectileParameters.lifespan or 13
	self.damage = projectileParameters.damage or 0
end

-- don't override this if messing with lifespan behavior
function Projectile:update(dt)
	local collision = CombatArena:GetFromMap('agents', self.location)
	if self.collidedWithWall or collision ~= nil then
		self:collide(collision)
		self:die()
		return
	end
	self.lifeTimer = self.lifeTimer - dt
	if self.lifeTimer <= 0 then
		self:die()
	end
end

-- override this for subclass lifespan behavior
-- other can be nil (if colliding with wall)
function Projectile:collide(other)
	if other then
		other:ChangeHealth(-self.damage)
	end
end

function Projectile:die()
	CombatArena:Despawn(self)
end

return Projectile
