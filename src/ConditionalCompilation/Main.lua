-- global conditional table, used to define flags for code (ie, __COND__.debug)
-- to set a flag, include a file with that name in the same directory as this file
__COND__ = {}

local thisFile = debug.getinfo(1, 'S').source:match("^.+/(.+)$")

local pfile = io.popen('ls -a ConditionalCompilation/')
for filename in pfile:lines() do
	if filename ~= '.' and filename ~= '..' and filename ~= thisFile then
		__COND__[filename] = true
	end
end
pfile:close()
