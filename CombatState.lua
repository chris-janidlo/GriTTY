-- hump style gamestate that handles combat stage (arena and terminal instance)

local Terminal = require 'Terminal'
local CombatArena = require 'CombatArena'
local Vector = require 'hump.vector'

local CombatState = {}

function CombatState:enter(previous)
	self.arenaShape = {
		dimensions = Vector(love.graphics.getHeight(), love.graphics.getHeight()), -- biggest square we can get
		location = Vector(0, 0)
	}
	self.terminalShape = {
		dimensions = Vector(self.arenaShape.dimensions.x, love.graphics.getHeight()), -- after taking away the arena space, this is the remaining rectangle
		location = Vector(self.arenaShape.dimensions.x, 0) -- upper right corner of arena == upper left of terminal
	}
	CombatArena:initialize(self.arenaShape.dimensions / 2)
	Terminal:initialize(Vector(self.terminalShape.location.x + 5, self.terminalShape.dimensions.y - 5)) -- 5 pixels in either direction from bottom left
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
