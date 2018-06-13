local Class = require 'hump.class'
local Timer = require 'hump.timer'
local Base = require 'Projectiles.Base'
local colors = require 'ColorDefinitions'

local Wind = Class{__includes = Base}

-- meaningful projectileParameters:
	-- healthMod
	-- lifespan
	-- timePerTile
function Wind:init(indicator, location, direction, projectileParameters)
	projectileParameters.direction = direction
	projectileParameters.lifespan = projectileParameters.lifespan or 5
	Base.init(self, indicator, location, projectileParameters)
	self.color = colors.fluidBlue
	self.healthMod = projectileParameters.healthMod or 2
end

function Wind:update(dt)
	if self.passenger then
		self.passenger.location = self.location
	end
	Base.update(self, dt)
end

function Wind:collide(other)
	if other and other.location and not self.passenger then
		self.passenger = other
		self.healthModCache = other.healthMod
		other.healthMod = self.healthMod
	end
	if not other then
		-- collided with wall
		self:die()
	end
end

function Wind:die()
	if self.passenger then
		Timer.after(.1, function () self.passenger.healthMod = self.healthModCache end)
	end
	Base.die(self)
end

return Wind
