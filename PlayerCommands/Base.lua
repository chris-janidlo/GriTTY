local PointField = require 'DataStructures.StaticIntPointField'
local Projectile = require 'Projectile'
local colors = require 'ColorDefinitions'

local function playerPrint(t, name)
	t:print('evaluating "'..name..'"')
end

local function move(name, point, i)
	return {
		name = name,
		helpString = 'move one tile',
		helpOrder = 0 + i,
		isPlayer = true,
		action = function(terminal, player, wait)
			playerPrint(terminal, name)

			player:setColor(colors.playerActing)
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

			player:setColor(colors.playerActing)
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

local dir = {
	-- cardinal
	up = PointField(0, -1),
	left = PointField(-1, 0),
	down = PointField(0, 1),
	right = PointField(1, 0),
	-- corners
	up_right = PointField(1, -1),
	up_left = PointField(-1, -1),
	down_left = PointField(-1, 1),
	down_right = PointField(1, 1),
}

local cmds = {}

cmds.w = move('w', dir.up, 1)
cmds.a = move('a', dir.left, 2)
cmds.s = move('s', dir.down, 3)
cmds.d = move('d', dir.right, 4)

cmds.ww = dodge('ww', dir.up, 1)
cmds.aa = dodge('aa', dir.left, 2)
cmds.ss = dodge('ss', dir.down, 3)
cmds.dd = dodge('dd', dir.right, 4)

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
			player:setColor(colors.playerActing)
			wait(s)
			player:setColor()
			terminal:print('done waiting.')
		end
	end
}

cmds.blt = {
	name = 'blt',
	helpString = 'offensive blit in square around user',
	isPlayer = true,
	action = function(terminal, player, wait)
		-- TODO: animate inner then outer circle
		playerPrint(terminal, 'blt')
		
		player:setColor(colors.playerActing)
		local indicators = {
			'\\', '\\', '|',  '/',  '/',

			'\\',                   '/',

			'-',    --[[ o ]]       '-',

			'/',                   '\\',
			
			'/',  '/',  '|', '\\', '\\'
		}
		local circle = {
			-- ordered exclusively so that indicators can look cool
			dir.up_left * 2,			-- \
			dir.up + dir.up_left,		-- \
			dir.up * 2,					-- |
			dir.up + dir.up_right,		-- /
			dir.up_right * 2,			-- /
			dir.left + dir.up_left,		-- \
			dir.right + dir.up_right,	-- /
			dir.left * 2,				-- -
			dir.right * 2,				-- -
			dir.left + dir.down_left,	-- /
			dir.right + dir.down_right,	-- \
			dir.down_left * 2,			-- /
			dir.down + dir.down_left,	-- /
			dir.down * 2,				-- |
			dir.down + dir.down_right,	-- \
			dir.down_right * 2			-- \
		}
		for i,v in ipairs(circle) do
			local proj = Projectile(indicators[i], player.location + v, .4, 40)
			proj:setColor(colors.red)
			CombatArena:Spawn(proj, 'projectiles')
		end
		wait(.2)
		player:setColor()
	end
}

return cmds
