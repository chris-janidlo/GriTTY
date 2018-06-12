local Class = require 'hump.class'
local Projectile = require 'Projectile'
local Colors = require 'ColorDefinitions'
local Directions = require 'Directions'
local Particle = require 'StaticParticle'
local ut = require 'Utilities'

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

function Fireball:die ()
	for i,v in ipairs(Directions.Circles[1].vectors) do
		local p = Particle('.', self.location + v, ut.random(.13, .37))
		p.color = Colors.harmlessOrange
		CombatArena:Spawn(p, 'particles')
	end
	Projectile.die(self)
end

return Fireball
