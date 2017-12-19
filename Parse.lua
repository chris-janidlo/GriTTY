local Class = require 'hump.class'

local Parse = Class{}

-- commands: map from command name to command object
-- Parse doesn't care what a command object looks like, but since the allCommands method returns strings, avoid making command objects strings so that the difference can be seen
	-- shouldn't be an issue but ya never know doncha know
function Parse:init(commands)
	self.commands = commands
end

function Parse:addCommand(name, command)
	self.commands[name] = command
end

function Parse:addCommands(commands)
	for k,v in pairs(commands) do
		self:addCommand(k, v)
	end
end

-- takes a string
-- returns array of tables, each with following format:
	-- {
		-- command = 'string',
		-- args = { 'string', 'string', '...', 'string' }
	-- }
-- the 'command' attribute is the first word of every semicolon-separated group. 'args' is an array containing every other word
local function deserialize(str)
	local cmds = {}
	
	local i = 1
	for command in (str..';'):gmatch('([^;]*);') do
		cmds[i] = {}
		cmds[i].args = {}
		local first = true
		for arg in command:gmatch('%w+') do
			if first then
				cmds[i].command = arg
				first = false
			else
				table.insert(cmds[i].args, arg) end
		end
		i = i + 1
	end

	return cmds
end

-- iterator that returns pairs of commands and argument lists from the given input
-- input: string of colon separated commands, each followed by space separated arguments
-- for every input command, we index this Parse objects commands table
	-- if we get a value: return that value, and the argument list given with the command
	-- if not: return the command as a string, so that an error message can be shown
function Parse:parse(input)
	local commandList = deserialize(input)
	local i = 0
	local iter
	iter = function()
		i = i + 1
		local parseCommandObject = commandList[i]
		if parseCommandObject then
			if not parseCommandObject.command then
				iter()
				return
			end
			local command = self.commands[parseCommandObject.command]
			if command then
				return command, parseCommandObject.args
			else
				return parseCommandObject.command
			end
		end
		return nil -- we've scanned the whole deserialize list, we're done here
	end

	return iter
end


return Parse
