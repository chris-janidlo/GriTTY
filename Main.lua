local GameObject = require 'GameObject'
local Signal = require 'hump.signal'
local Terminal = require 'Terminal'
local Timer = require 'hump.timer'
local CombatArena = require 'CombatArena'

function love.load()
	MainFont = love.graphics.setNewFont('Monoid/Monoid-Regular.ttf')
	GameObject:CallAll('load')
end

function love.textinput(key)
	GameObject:CallAll('textinput', key)
end

function love.keypressed(key, scanline, isrepeat)
	GameObject:CallAll('keypressed', key, scanline, isrepeat)
end

function love.update(dt)
	GameObject:CallAll('update', dt)
	Timer.update(dt)
end

function love.draw()
	GameObject:CallAll('draw')
end

Signal.register('tty_text_input', function (input)
	print(input)
end)
