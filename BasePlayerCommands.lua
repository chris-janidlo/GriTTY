local PointField = require 'DataStructures.StaticIntPointField'

local cmds = {}

-- expansions
cmds._e = {
	-- wasd
	w = PointField(0, -1),
	a = PointField(-1, 0),
	s = PointField(0, 1),
	d = PointField(1, 0)
}

function cmds.addToPlayerPos(player, point)
	newPoint = player.location + point
	player.location = PointField(newPoint.x, newPoint.y)
end

function cmds.move(point)
	return {
		{
			function(player) player:setColor(255,0,0) end,
			.15
		},
		{
			function(player) cmds.addToPlayerPos(player, point) end,
			.2
		},
		{
			function(player) player:setColor() end,
			0
		}
	}
end

function cmds.dodge(direction)
	return {
		{
			function(player) player:setColor(255,0,0) end,
			.15
		},
		{
			function(player) player.invuln = true; player:setIndicator('.'); cmds.addToPlayerPos(player, direction*2) end,
			.25
		},
		{
			function(player) cmds.addToPlayerPos(player, direction); player:resetIndicator() end,
			.5
		},
		{
			function(player) player.invuln = false; player:setColor() end,
			0
		}
	}
end

cmds.w = cmds.move(cmds._e.w)
cmds.a = cmds.move(cmds._e.a)
cmds.s = cmds.move(cmds._e.s)
cmds.d = cmds.move(cmds._e.d)

cmds.ww = cmds.dodge(cmds._e.w)
cmds.aa = cmds.dodge(cmds._e.a)
cmds.ss = cmds.dodge(cmds._e.s)
cmds.dd = cmds.dodge(cmds._e.d)

return cmds
