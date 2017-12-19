-- main menu, more or less
local Terminal = require 'Terminal'
local CombatState = require 'CombatState'
local Parse = require 'Parse'
local BaseCommands = require 'BaseCommands'
local Vector = require 'hump.vector'
local Gamestate = require 'hump.gamestate'

local LogonShell = {}

local cmds = {
	fight = {
		name = 'fight',
		helpString = 'launch combat daemon',
		action = function() Gamestate.push(CombatState) end
	},
	exit = {
		name = 'exit',
		helpOrder = -30,
		helpString = 'exit application',
		action = function() love.event.quit() end
	}
}

function LogonShell:execute(input)
	for command, arguments in self.p:parse(input) do
		if type(command) == 'table' then
			if command.name == 'help' then
				command.action(self.t, self.p)
			else
				command.action(self.t, arguments)
			end
		else
			self.t:print('command "'..command..'" not recognized', true)
		end
	end
end

function LogonShell:enter(previous)
	self.t = Terminal(Vector(5, love.graphics.getHeight() - 5), true)
	self.p = Parse(BaseCommands)
	self.p:addCommands(cmds)

	self.t:print('This is a work in progress (WIP) software that is provided AS IS and without warranty. Any damages caused to the user are not the liability of Crass Sandwich Ent. or any of its shareholders, subsidiaries, or employees. Type "help" for help.')
end

function LogonShell:resume()
	self.t:setActive()
end

function LogonShell:update(dt)
	local input = self.t:popInput()
	if input then self:execute(input) end
end

function LogonShell:draw()
	self.t:draw()
end

function LogonShell:textinput(key)
	self.t:textinput(key)
end

function LogonShell:keypressed(key)
	self.t:keypressed(key)
end

return LogonShell