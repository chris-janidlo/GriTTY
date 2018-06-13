local Projectile = require 'Projectiles.Base'
local Fireball = require 'Projectiles.Fireball'
local Wind = require 'Projectiles.Wind'
local colors = require 'ColorDefinitions'
local glyphs = require 'FontGlyphDefinitions'
local dir = require 'Directions'

local function playerPrint(t, name)
	t:print('evaluating "'..name..'"')
end

local function errPrint(t, badVal, whyValIsBad)
	t:print("'"..(badVal or '').."' "..whyValIsBad, colors.errorMessage)
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
		playerPrint(terminal, 'wait')

		local s = tonumber(seconds)
		if s == nil then
			errPrint(terminal, seconds, 'is not a number')
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
		for i,v in ipairs(dir.Squares[2].vectors) do
			local proj = Projectile(dir.Squares[2].indicators[i], player.location + v, {lifespan = .4, damage = 40})
			proj:setColor(colors.red)
			CombatArena:Spawn(proj, 'projectiles')
		end
		wait(.2)
		player:setColor()
	end
}

cmds.proc = {
	name = 'proc dir',
	helpString = 'launch adversarial process in the given direction',
	isPlayer = true,
	action = function(terminal, player, wait, dirArg)
		playerPrint(terminal, 'proc')
		
		local direction = dir[dirArg]
		if not dir:IsCardinal(direction) then
			errPrint(terminal, dirArg, 'is not a valid cardinal direction')
		else
			player:setColor(colors.playerActing)
			local ball = Fireball('*', player.location + direction, direction)
			CombatArena:Spawn(ball, 'projectiles')
			wait(1)
			player:setColor()
		end
	end
}

cmds.bmp = {
	name = 'bmp',
	helpString = 'push outward. makes ',
	isPlayer = true,
	action = function(terminal, player, wait)
		playerPrint(terminal, 'bmp')

		player:setColor(colors.playerActing)
		for i,v in ipairs(dir.Squares[1].vectors) do
			-- wind pushes out for two tiles
			local wind = Wind(glyphs.fluid, player.location + v, v, {timePerTile = .2, lifespan = .4})
			CombatArena:Spawn(wind, 'projectiles')
		end
		-- wait long enough for combos
		wait(.405)
		player:setColor()
	end
}

return cmds
