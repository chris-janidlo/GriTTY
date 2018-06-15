-- main menu, more or less
local Terminal = require 'Gamestate.Terminal'
local CombatState = require 'Gamestate.CombatState'
local Parse = require 'PlayerCommands.Parser'
local BaseCommands = require 'PlayerCommands.Core'
local colors = require 'Definitions.Colors'
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
			self.t:print('command "'..command..'" not recognized', colors.errorMessage)
		end
	end
end

function LogonShell:enter(previous)
	self.t = Terminal(Vector(5, love.graphics.getHeight() - 5), true)
	self.p = Parse(BaseCommands)
	self.p:addCommands(cmds)

	self.t:print([[
GryTTY version 1.37

User understands that software is experimental. Crass Sandwich Ent. makes no representations or warranties of any kind.

Ready


Type "help" for help.

]])
end

function LogonShell:resume()
	self.t:makeActive()
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