local Signal = require 'hump.signal'
local Parse = require 'Parse'
local commands = require 'BasePlayerCommands'

Signal.register('tty_stdin', function(input)
	local richInput = Parse.parse(input)
	if #input == 0 then return end
	for i,richCommand in ipairs(richInput) do
		if richCommand.command then
			if commands[richCommand.command] then
				Signal.emit('tty_stdout', 'executing action \''..richCommand.command..'\'...')
				Player:action(commands[richCommand.command], unpack(richCommand.args))
			else
				Signal.emit('tty_stderr', 'command \''..richCommand.command..'\' not recognized')
			end
		end
	end
end)
