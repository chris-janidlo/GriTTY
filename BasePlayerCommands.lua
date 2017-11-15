local IntPoint = require 'IntPoint'

local cmds = {}

-- expansions
cmds._e = {
	-- wasd
	w = IntPoint(0, -1),
	a = IntPoint(-1, 0),
	s = IntPoint(0, 1),
	d = IntPoint(1, 0)
}

function cmds.move(point)
	return {
		{
			function(player) player:setColor(255,0,0) end,
			.25
		},
		{
			function(player) player:setLocation(player:getLocation() + point) end,
			.25
		},
		{
			function(player) player:setColor() end,
			0
		}
	}
end

cmds.w = cmds.move(cmds._e.w)
cmds.a = cmds.move(cmds._e.a)
cmds.s = cmds.move(cmds._e.s)
cmds.d = cmds.move(cmds._e.d)

return cmds
