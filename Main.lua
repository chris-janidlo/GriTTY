local Gamestate = require 'hump.gamestate'
local Signal = require 'hump.signal'
local Timer = require 'hump.timer'
local CombatState = require 'CombatState'

local function roundToNearest(value, rounder)
	return math.floor(value / rounder) * rounder
end

function love.load()
	MainFont = love.graphics.setNewFont('Monoid/Monoid-Regular.ttf')
	local height = MainFont:getHeight()
	love.window.setMode(roundToNearest(love.graphics.getWidth(), height), roundToNearest(love.graphics.getHeight(), height))
	Gamestate.registerEvents()
	Gamestate.switch(CombatState)
end

function love.update(dt)
	Timer.update(dt)
end

Signal.register('tty_stdin', function (input)
	print(input)
end)
