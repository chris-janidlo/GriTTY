local Signal = require 'hump.signal'
local commands = require 'BasePlayerCommands'

-- takes a string of bash-kinda commands (that is, commands with space-separated argument lists, which one level up are separated by colons)
-- returns array of tables, each with following format:
	-- {
		-- command = 'string',
		-- args = { 'string', 'string', '...', 'string' }
	-- }
-- the 'command' attribute is the first word of every semicolon-separated group. 'args' is an array containing every other word.
local function parse(str)
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

Signal.register('tty_stdin', function(input)
	if #input == 0 then return end
	if Player.acting then
		Signal.emit('tty_stderr', 'player agent is already executing an action')
		return
	end

	local richInput = parse(input)
	
	for i,richCommand in ipairs(richInput) do
		if richCommand.command then
			if commands[richCommand.command] then
				Player.actionQueue:push({name = richCommand.command, action = commands[richCommand.command], args = richCommand.args})
			else
				Signal.emit('tty_stderr', 'command \''..richCommand.command..'\' not recognized')
			end
		end
	end
end)
