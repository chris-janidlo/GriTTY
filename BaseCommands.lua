---------- COMMAND FORMAT ----------
-- table with following values
-- name: command name (redundant but useful)
-- helpString: printed when 'help' command is run
-- helpOrder: optional. if present, determines order that this shows up in the help string. lower => higher on the screen. if not present, will be shown at the bottom. ties are broken lexicographically
-- action: function that defines the command's behavior. should always be passed the terminal instance of the calling context

local cmds = {}

cmds.help = {
	name = 'help',
	helpString = 'print this message',
	helpOrder = -50,
	action = function(terminal)
		local function helpSort(cmd1, cmd2)
			local a, b = cmd1.helpOrder or 137137137137137137137137137137137137137, cmd2.helpOrder or 137137137137137137137137137137137137137
			if a ~= b then
				return a < b
			else
				return cmd1.helpString < cmd2.helpString
			end
		end

		terminal:print('GriTTY version 1.37')
		local order = {}
		for s, cmd in pairs(cmds) do
			table.insert(order, cmd)
		end
		table.sort(order, helpSort)
		for i,cmd in ipairs(order) do
			terminal:print(cmd.name..':\t'..cmd.helpString)
		end
	end
}

cmds.exit = {
	name = 'exit',
	helpString = 'exit current application and return to previous',
	helpOrder = -30,
	action = function(terminal)
		terminal:print('NOT IMPLEMENTED', true)
	end
}

return cmds
