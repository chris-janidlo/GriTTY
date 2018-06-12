-- hump style gamestate that handles combat stage (arena and terminal instance)

local Terminal = require 'Terminal'
local Vector = require 'hump.vector'
local colors = require 'ColorDefinitions'

local Parse = require 'Parse'
local BaseCommands = require 'BaseCommands'
local PlayerCommands = require 'PlayerCommands.Base'

local CombatState = {}

function CombatState:enter(previous)
	CombatArena:initialize(16, 16)

	self.t = Terminal(Vector(
		CombatArena.rectLocation.x + CombatArena.rectDimensions.x + MainFont:getWidth(' '),
		love.graphics.getHeight() - MainFont:getHeight()
	), true)
	
	self.p = Parse(BaseCommands)
	self.p:addCommands(PlayerCommands)
end

function CombatState:leave()
	CombatArena:deinitialize()
end

function CombatState:execute(input)
	for command, arguments in self.p:parse(input) do
		if type(command) == 'table' then
			if command.isPlayer then
				if Player.acting then
					self.t:print('added "'..command.name..'" to queue.')
				end
				Player:pushAction(command, arguments)
			else
				if command.name == 'help' then
					command.action(self.t, self.p)
				else
					command.action(self.t, arguments)
				end
			end
		else
			self.t:print('command "'..command..'" not recognized', colors.errorMessage)
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
	love.graphics.print("FPS:"..love.timer.getFPS(),0,0)
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
