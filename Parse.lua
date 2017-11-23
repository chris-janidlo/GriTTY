local Parse = {}

-- takes a string of bash-kinda commands (that is, commands with space-separated argument lists, which one level up are separated by colons)
-- returns array of tables, each with following format:
	-- {
		-- command = 'string',
		-- args = { 'string', 'string', '...', 'string' }
	-- }
-- the 'command' attribute is the first word of every semicolon-separated group. 'args' is an array containing every other word.
function Parse.parse(str)	
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

return Parse
