-- hump style gamestate that handles combat stage (arena and terminal instance)

local Terminal = require 'Terminal'
local CombatArena = require 'CombatArena'
local Vector = require 'hump.vector'

local Parse = require 'Parse'
local BaseCommands = require 'BaseCommands'
local PlayerCommands = require 'PlayerCommands.Base'

local CombatState = {}

function CombatState:enter(previous)
	CombatArena:initialize(16, 16, self.t)

	self.t = Terminal(Vector(
		CombatArena.rectLocation.x + CombatArena.rectDimensions.x + MainFont:getWidth(' '),
		love.graphics.getHeight() - MainFont:getHeight()
	), true)
	
	self.p = Parse(BaseCommands)
	self.p:addCommands(PlayerCommands)
end

function CombatState:execute(input)
	for command, arguments in self.p:parse(input) do
		if type(command) == 'table' then
			if command.isPlayer then
				if Player.acting then
					self.t:print('added to queue')
				end
				Player:pushAction(command, arguments)
			else
				command.action(self.t, arguments)
			end
		else
			self.t:print('command "'..command..'" not recognized', true)
		end
	end
end

function CombatState:update(dt)
	CombatArena:update(dt)
	local input = self.t:popInput()
	if input then
		CombatState:execute(input)
	end
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
