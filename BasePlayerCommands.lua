local PointField = require 'DataStructures.StaticIntPointField'

local function move(point)
	return {
		{
			function(player) player:setColor(player.actingColor) end,
			.15
		},
		{
			function(player) player.location = player.location + point end,
			.2
		},
		{
			function(player) player:setColor() end,
			0
		}
	}
end

local function dodge(direction)
	return {
		{
			function(player) player:setColor(player.actingColor) end,
			.15
		},
		{
			function(player) player.invuln = true; player:setIndicator('.'); player.location = player.location + direction*2 end,
			.25
		},
		{
			function(player) player.location = player.location + direction; player:resetIndicator() end,
			.5
		},
		{
			function(player) player.invuln = false; player:setColor() end,
			0
		}
	}
end

-- expansions
local e = {
	-- wasd
	w = PointField(0, -1),
	a = PointField(-1, 0),
	s = PointField(0, 1),
	d = PointField(1, 0)
}

local cmds = {}

cmds.w = move(e.w)
cmds.a = move(e.a)
cmds.s = move(e.s)
cmds.d = move(e.d)

cmds.ww = dodge(e.w)
cmds.aa = dodge(e.a)
cmds.ss = dodge(e.s)
cmds.dd = dodge(e.d)

return cmds
