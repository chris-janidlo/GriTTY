local Gamestate = require 'hump.gamestate'

local Pause = {}

function Pause:init()
	self.message = 'SUSPENDED'
	self.scale = 1
end

function Pause:draw()
	local origin = {
		x = love.graphics.getWidth() / 2,
		y = love.graphics.getHeight() / 2
	}
	local offset = {
		x = MainFont:getWidth(self.message) * self.scale / 2,
		y = MainFont:getHeight() * self.scale / 2
	}
	love.graphics.print(self.message, origin.x - offset.x, origin.y - offset.y, 0, self.scale)
end

function Pause:keypressed(key, scancode, isrepeat)
	if key == 'escape' then
		return Gamestate.pop()
	end
end

return Pause
