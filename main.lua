local Entities = require 'ecs'
local Signal = require 'hump.signal'
local terminal = require 'terminal'

function love.load()
	MainFont = love.graphics.setNewFont('Monoid/Monoid-Regular.ttf')
	Entities.CallAll('load')
end

function love.textinput(key)
	Entities.CallAll('textinput', key)
end

function love.keypressed(key, scanline, isrepeat)
	Entities.CallAll('keypressed', key, scanline, isrepeat)
end

function love.update(dt)
	Entities.CallAll('update', dt)
end

function love.draw()
	Entities.CallAll('draw')
end

Signal.register('tty_text_input', function (input)
	print(input)
end)
