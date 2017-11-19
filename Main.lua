local Gamestate = require 'hump.gamestate'
local Signal = require 'hump.signal'
local Timer = require 'hump.timer'
local CombatState = require 'CombatState'

function love.load()
	MainFont = love.graphics.setNewFont('Monoid/Monoid-Regular.ttf')
	Gamestate.registerEvents()
	Gamestate.switch(CombatState)
end

function love.update(dt)
	Timer.update(dt)
end

Signal.register('tty_stdin', function (input)
	print(input)
end)
