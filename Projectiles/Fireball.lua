local Class = require 'hump.class'
local Projectile = require 'Projectile'
local Colors = require 'ColorDefinitions'
local Directions = require 'Directions'
local Particle = require 'StaticParticle'

local Fireball = Class{__includes = Projectile}

function Fireball:init(indicator, location, direction, projectileParameters)
	Projectile.init(self, indicator, location, projectileParameters)
	self.direction = direction
	self.timePerTile = projectileParameters.timePerTile or .25
	self.timer = 0
	self.color = Colors.red
end

function Fireball:update(dt)
	Projectile.update(self, dt)
	self.timer = self.timer + dt
	if self.timer >= self.timePerTile then
		self.timer = 0
		self.location = self.location + self.direction
	end
end

function Fireball:collide (other)
	Projectile.collide(self, other)
	for i,v in ipairs(Directions.Squares[1].vectors) do
		local p = Particle('.', self.location + v, love.math.random(.3, .7))
		p.color = Colors.harmlessOrange
		CombatArena:Spawn(p, 'particles')
	end
end

return Fireball
