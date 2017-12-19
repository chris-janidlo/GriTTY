local Gamestate = require 'hump.gamestate'
local Timer = require 'hump.timer'
local CombatState = require 'CombatState'
local Pause = require 'Pause'

local function roundToNearest(value, rounder)
	return math.floor(value / rounder) * rounder
end

function love.load()
	love.keyboard.setKeyRepeat(true)
	MainFont = love.graphics.setNewFont('Monoid/Monoid-Regular.ttf')
	local height = MainFont:getHeight()
	love.window.setMode(roundToNearest(love.graphics.getWidth(), height), roundToNearest(love.graphics.getHeight(), height))
	Gamestate.registerEvents()
	Gamestate.switch(CombatState)
end

function love.update(dt)
	Timer.update(dt)
end

function love.keypressed(key, scancode, isrepeat)
	if Gamestate.current() ~= Pause and key == 'escape' then
		Gamestate.push(Pause)
	end
end
