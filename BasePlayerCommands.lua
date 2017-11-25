local PointField = require 'DataStructures.StaticIntPointField'

local function addToPlayerPos(player, point)
	newPoint = player.location + point
	player.location = PointField(newPoint.x, newPoint.y)
end

local function move(point)
	return {
		{
			function(player) player:setColor(255,0,0) end,
			.15
		},
		{
			function(player) addToPlayerPos(player, point) end,
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
			function(player) player:setColor(255,0,0) end,
			.15
		},
		{
			function(player) player.invuln = true; player:setIndicator('.'); addToPlayerPos(player, direction*2) end,
			.25
		},
		{
			function(player) addToPlayerPos(player, direction); player:resetIndicator() end,
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
