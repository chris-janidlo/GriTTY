local IntPoint = require 'IntPoint'

local commands = {}

function commands.move(point)
	return function(player)
		return function(wait)
			player.animating = true; player.color[2], player.color[3] = 0, 0
			wait(.25)
			player:setLocation(player:getLocation() + point)
			wait(.25)
			player.animating = false; player.color[2], player.color[3] = 255, 255
		end
	end
end

commands.w = commands.move(IntPoint(0, -1))
commands.a = commands.move(IntPoint(-1, 0))
commands.s = commands.move(IntPoint(0, 1))
commands.d = commands.move(IntPoint(1, 0))

return commands
