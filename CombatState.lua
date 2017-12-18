-- hump style gamestate that handles combat stage (arena and terminal instance)

local Terminal = require 'Terminal'
local CombatArena = require 'CombatArena'
local Vector = require 'hump.vector'

local CombatState = {}

function CombatState:enter(previous)
	CombatArena:initialize(16, 16)

	self.t = Terminal(Vector(
		CombatArena.rectLocation.x + CombatArena.rectDimensions.x + MainFont:getWidth(' '),
		love.graphics.getHeight() - MainFont:getHeight()
	))
end

function CombatState:update(dt)
	CombatArena:update(dt)
	local v = self.t:popInput()
	if v then print(v) end
end

function CombatState:draw()
	self.t:draw()
	CombatArena:draw()
end

function CombatState:textinput(key)
	self.t:textinput(key)
end

function CombatState:keypressed(key)
	self.t:keypressed(key)
end

return CombatState
