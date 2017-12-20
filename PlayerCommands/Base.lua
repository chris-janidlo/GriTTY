local PointField = require 'DataStructures.StaticIntPointField'
local colors = require 'ColorDefinitions'

local function playerPrint(t, name)
	t:print('executing action \''..name..'\'...')
end

local function move(name, point, i)
	return {
		name = name,
		helpString = 'move one tile',
		helpOrder = 0 + i,
		isPlayer = true,
		action = function(terminal, player, wait)
			playerPrint(terminal, name)

			player:setColor(player.actingColor)
			wait(.15)
			player.location = player.location + point
			wait(.2)
			player:setColor()
		end
	}
end

local function dodge(name, direction, i)
	return {
		name = name,
		helpString = 'move three tiles and dodge attacks',
		helpOrder = 10 + i,
		isPlayer = true,
		action = function(terminal, player, wait)
			playerPrint(terminal, name)

			player:setColor(player.actingColor)
			wait(.15)

			player.invuln = true; player:setIndicator('.')
			player.location = player.location + direction * 2
			wait(.25)
			
			player.location = player.location + direction
			player:resetIndicator()
			wait(.5)

			player.invuln = false; player:setColor()
		end
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

cmds.w = move('w', e.w, 1)
cmds.a = move('a', e.a, 2)
cmds.s = move('s', e.s, 3)
cmds.d = move('d', e.d, 4)

cmds.ww = dodge('ww', e.w, 1)
cmds.aa = dodge('aa', e.a, 2)
cmds.ss = dodge('ss', e.s, 3)
cmds.dd = dodge('dd', e.d, 4)

cmds.wait = {
	name = 'wait x',
	helpString = 'wait for x seconds',
	isPlayer = true,
	action = function(terminal, player, wait, seconds)
		local s = tonumber(seconds)
		if s == nil then
			terminal:print((seconds or '')..' is not a number', colors.errorMessage)
		else
			terminal:print('waiting for '..s..' seconds...')
			player:setColor(player.actingColor)
			wait(s)
			player:setColor()
			terminal:print('done waiting.')
		end
	end
}

return cmds
