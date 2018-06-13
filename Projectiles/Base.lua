local Class = require 'hump.class'
local Vector = require 'hump.vector'
local CombatEntity = require 'CombatEntity'

local Projectile = Class{__includes = CombatEntity}

-- meaningful projectileParamters:
	-- timePerTile
	-- direction
	-- lifespan
	-- damage
function Projectile:init(indicator, location, projectileParameters)
	CombatEntity.init(self, indicator, location)
	self.direction = projectileParameters.direction or Vector(0,0)
	self.lifeTimer = projectileParameters.lifespan or 13
	self.damage = projectileParameters.damage or 0
	self.timePerTile = projectileParameters.timePerTile or .25
	self.moveTimer = 0
end

-- don't override this if messing with lifespan behavior
function Projectile:update(dt)
	local collision = CombatArena:GetFromMap('agents', self.location)
	if self.collidedWithWall or collision ~= nil then
		self:collide(collision)
	end
	self.lifeTimer = self.lifeTimer - dt
	if self.lifeTimer <= 0 then
		self:die()
	end
	self.moveTimer = self.moveTimer + dt
	if self.moveTimer >= self.timePerTile then
		self:moveTick()
	end
end

-- override this for subclass lifespan behavior
-- other can be nil (if colliding with wall)
function Projectile:collide(other)
	if other then
		other:ChangeHealth(-self.damage)
	end
	self:die()
end

function Projectile:die()
	CombatArena:Despawn(self)
end

function Projectile:moveTick()
	self.moveTimer = 0
	self.location = self.location + self.direction
end

return Projectile
