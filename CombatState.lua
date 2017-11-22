-- hump style gamestate that handles combat stage (arena and terminal instance)

local Terminal = require 'Terminal'
local CombatArena = require 'CombatArena'
local CommandExec = require 'PlayerCommandExecution'
local Vector = require 'hump.vector'

local CombatState = {}

function CombatState:enter(previous)
	CombatArena:initialize(16, 16)

	Terminal:initialize(Vector(
		CombatArena.rectLocation.x + CombatArena.rectDimensions.x + MainFont:getWidth(' '),
		love.graphics.getHeight() - MainFont:getHeight()
	))
end

function CombatState:update(dt)
	CombatArena:update(dt)
end

function CombatState:draw()
	Terminal:draw()
	CombatArena:draw()
end

function CombatState:textinput(key)
	Terminal:textinput(key)
end

function CombatState:keypressed(key)
	Terminal:keypressed(key)
end

return CombatState
