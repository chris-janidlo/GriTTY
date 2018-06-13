local Class = require 'hump.class'
local Base = require 'Projectiles.Base'
local Colors = require 'Definitions.Colors'
local Directions = require 'Definitions.Geometry'
local Particle = require 'Particles.Static'
local ut = require 'Util.Misc'

local Fireball = Class{__includes = Base}

-- even though this is a projectile, it completely ignores given projectileParameters
function Fireball:init(indicator, location, direction)
	Base.init(self, indicator, location, {direction = direction, damage = 50, timePerTile = .75})
	self.color = Colors.red
end

function Fireball:die ()
	for i,v in ipairs(Directions.Circles[1].vectors) do
		local p = Particle('.', self.location + v, ut.random(.13, .37))
		p.color = Colors.harmlessOrange
		CombatArena:Spawn(p, 'particles')
	end
	Base.die(self)
end

function Fireball:moveTick()
	Base.moveTick(self)
	self.damage = self.damage + 15
end

return Fireball
