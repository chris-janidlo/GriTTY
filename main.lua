Entities = require 'ecs'

function love.load()
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
