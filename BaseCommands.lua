local Signal = require 'hump.signal'
local PointField = require 'DataStructures.StaticIntPointField'

---------- COMMAND FORMAT ----------
-- table with following values
-- name: command name (redundant but useful)
-- actionFun: action function (see CombatEntity) OR simple function for shell commands
-- helpString: printed when 'help' command is run
-- isPlayer: set to true if actionFun acts on a Player

local function move(name, point)
	return {
		name = name,
		actionFun = function(wait, player)
			player:setColor(player.actingColor)
			wait(.15)
			player.location = player.location + point
			wait(.2)
			player:setColor()
		end,
		helpString = 'move one tile',
		isPlayer = true
	}
end

local function dodge(name, direction)
	return {
		name = name,
		actionFun = function(wait, player)
			player:setColor(player.actingColor)
			wait(.15)

			player.invuln = true; player:setIndicator('.')
			player.location = player.location + direction * 2
			wait(.25)
			
			player.location = player.location + direction
			player:resetIndicator()
			wait(.5)

			player.invuln = false; player:setColor()
		end,
		helpString = 'move three tiles while invincible',
		isPlayer = true
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

cmds.w = move('w', e.w)
cmds.a = move('a', e.a)
cmds.s = move('s', e.s)
cmds.d = move('d', e.d)

cmds.ww = dodge('ww', e.w)
cmds.aa = dodge('aa', e.a)
cmds.ss = dodge('ss', e.s)
cmds.dd = dodge('dd', e.d)

cmds.help = {
	name = 'help',
	actionFun = function()
		print('GriTTY version 1.37')
		local order = {}
		for s, cmd in pairs(cmds) do
			table.insert(order, s..':\t'..cmd.helpString)
		end
		table.sort(order)
		for i,s in ipairs(order) do
			Signal.emit('tty_stdout', s)
		end
	end,
	helpString = 'print this message'
}

return cmds
