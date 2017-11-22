local Signal = require 'hump.signal'
local commands = require 'BasePlayerCommands'

Signal.register('tty_stdin', function(input)
	-- this is in a mock state. needs a dedicated toy parser for complex commands with arguments and things like command;command
	if commands[input] then
		Signal.emit('tty_stdout', 'executing action \''..input..'\'...')
		Player:action(commands[input])
	else Signal.emit('tty_stderr', 'command \''..input..'\' not recognized')
	end
end)
