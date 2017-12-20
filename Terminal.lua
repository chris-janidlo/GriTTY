local utf8 = require 'utf8'
local Class = require 'hump.class'
local ScrollbackBuffer = require 'DataStructures.ScrollbackBuffer'
local Timer = require 'hump.timer'
local Deque = require 'DataStructures.Deque'
local colors = require 'ColorDefinitions'

local Terminal = Class{}

---------- 'STATIC' VARIABLES ----------
Terminal._instances = {inactive = {}}
Terminal.blink_delay = 0.5

----------------------------------------------------------------------------
---------------------------- HELPER FUNCTIONS ------------------------------
----------------------------------------------------------------------------
-- don't call these externally

-- returns the current input string split around the current cursor position
-- if trim is true, it trims the left hand side by one character before returning
function Terminal:_split_at_cursor(trim)
	if #self.input == 0 then return self.input, '' end
	
	-- get the utf8 offset so that we trim the *character* at cursor_pos, not the byte
	local debut = utf8.offset(self.input, self.cursor_pos)
	local fin = utf8.offset(self.input, self.cursor_pos + 1)
	
	local left, right = '','' -- O_O
	if self.cursor_pos > -#self.input - 1 then
		left = string.sub(self.input, 1, trim and debut - 1 or debut)
	end
	if self.cursor_pos < -1 then
		right = string.sub(self.input, fin)
	end
	return left, right
end

-- promptY: y pixel value of the line of text where the prompt is printed
function Terminal:_cursor_pixel_position(promptY)
	local positive_pos = #self.input + self.cursor_pos
	local tmp = (positive_pos + #self.prompt)

	local x, y = tmp % self.charsPerLine, math.floor(tmp / self.charsPerLine)

	local charwidth = MainFont:getWidth(' ')
	local base = self.x + charwidth / 2

	return base + x * charwidth + 1, promptY + y * MainFont:getHeight() 
end

local function splitIntoEqualLines(text, length)
	if not text then return {} end
	local lines = {}
	local current = 1
	while current <= #text do
		lines[#lines+1] = text:sub(current, current + length-1)
		current = current + length
	end
	return lines
end

-- prints text in lines split by character with charLimit characters
-- x is just a basic x coordinate, but bottomY is the top pixel of the bottom line of text (all lines are printed above that)
-- returns the y coordinate of the top line of text so that this can be chained together (caller need to add space, however)
local function printMultiLine(text, charLimit, x, bottomY)
	local lines = splitIntoEqualLines(text, charLimit)
	local topY = bottomY - (#lines-1) * MainFont:getHeight()
	local curry = topY
	for i,line in ipairs(lines) do
		love.graphics.print(line, x, curry)
		curry = curry + MainFont:getHeight()
	end
	return topY
end

local function splitByNewline(s)
	if s:sub(-1)~="\n" then s=s.."\n" end
	local lines = {}
	for l in s:gmatch("(.-)\n") do
		-- we want to print empty lines in multi-line strings, such as a greeting message or cowsay
		-- however, in general, we don't want ot print an empty line for empty text input, ie pressing enter with no input
		-- so we compromize
		if #lines > 0 and l == '' then
			l = '\n'
		end
		table.insert(lines, l)
	end
	return lines
	-- if s:sub(-1)~="\n" then s=s.."\n" end
	-- return s:gmatch("(.-)\n")
end

-----------------------------------------------------------------------------------
---------------------------- INTERFACE FUNCTIONALITY ------------------------------
-----------------------------------------------------------------------------------

function Terminal:init(position, echo)
	self:makeActive()

	-- position to print terminal line (including prompt)
	self.x = position.x
	self.y = position.y - MainFont:getHeight()
	
	self.echo = echo
	self.prompt = '> '
	self.input = ''
	
	self.cursor_char = '|'
	self.cursor_pos = -1
	self.scrollback_pos = -1

	self.scrollback_out = ScrollbackBuffer(math.floor(love.graphics.getHeight() / MainFont:getHeight()))
	self.scrollback_in = ScrollbackBuffer(self.scrollback_out.capacity)
	self.input_queue = Deque.Queue()
	
	local alignLimit = love.graphics.getWidth() - self.x - MainFont:getWidth(' ') -- the space left for our terminal plus one character to look nice
	self.charsPerLine = math.floor(alignLimit / MainFont:getWidth(' '))
end

-- pop input to be processed externally
function Terminal:popInput()
	return self.input_queue:pop()
end

-- add text as a new entry in this this terminal's output scrollback
-- TODO: support multi colored strings
function Terminal:print(input, color)
	for i, text in ipairs(splitByNewline(input)) do
		self.scrollback_out:add({text, color or colors.white})
	end
end

function Terminal:setBlinking(active)
	if active == false then
		Timer.cancel(Terminal._instances.active._blink_handler)
	else
		self._blink_handler = Timer.every(Terminal.blink_delay, function()
			if self.cursor_char == '|' then
				self.cursor_char = ''
			else
				self.cursor_char = '|'
			end
		end)
	end		
end

-- temporarily pause blinking
-- for, ie, typing, hitting arrow, hitting return
function Terminal:pauseBlinking()
	self.cursor_char = '|'
	self:setBlinking(false)
	Timer.after(Terminal.blink_delay, self:setBlinking(true))
end

-- 'static' method; returns global active terminal instance
function Terminal.getActive()
	return Terminal._instances.active
end

-- deactivates any other terminal instances and sets this as the global active terminal
-- also turns cursor blinking on for this instance and off for every other instance
function Terminal:makeActive()
	if Terminal._instances.active then
		Terminal._instances.inactive[Terminal._instances.active] = true
		Terminal._instances.active:setBlinking(false)
	end
	Terminal._instances.inactive[self] = false
	Terminal._instances.active = self
	self:setBlinking(true)
end

--------------------------------------------------------------------------
---------------------------- LOVE CALLBACKS ------------------------------
--------------------------------------------------------------------------

-- basic text input
function Terminal:textinput(key)
	local l, r = self:_split_at_cursor()
	self.input = l .. key .. r
	self:pauseBlinking()
end

-- handles special key codes (ie backspace, return, arrow keys)
function Terminal:keypressed(key)
	self:pauseBlinking()

	if key == "backspace" then
		local l, r = self:_split_at_cursor(true)
		self.input = l .. r

	elseif key == "return" then
		self.input_queue:push(self.input)
		if self.input ~= '' then
			self.scrollback_in:add(self.input)
		end
		if (self.echo) then
			self.scrollback_out:add({self.prompt..self.input, {255, 255, 255}})
		end
		self.input = ""
		self.cursor_pos = -1
		self.scrollback_pos = -1

	elseif key == "left" then
		-- cursor can, at most, be one to the left of the current input (when we want to insert at the beginning)
		self.cursor_pos = math.max(-#self.input - 1, self.cursor_pos - 1)

	elseif key == "right" then
		self.cursor_pos = math.min(self.cursor_pos + 1, -1)
	
	elseif key == "up" then
		if self.scrollback_in:isEmpty() then return end
		self.scrollback_pos = math.min(self.scrollback_pos + 1, self.scrollback_in.fin - 1)
		self.input = self.scrollback_in:lookBackward(self.scrollback_pos)
		self.cursor_pos = -1

	elseif key == "down" then
		self.scrollback_pos = math.max(self.scrollback_pos - 1, -1)
		if self.scrollback_pos == -1 then
			self.input = ""
		else
			self.input = self.scrollback_in:lookBackward(self.scrollback_pos)
		end
		self.cursor_pos = -1

	end
end

function Terminal:draw()
	-- current input
	-- promptY: y value of the line of text with the prompt
	local promptY = printMultiLine(self.prompt..self.input, self.charsPerLine, self.x, self.y)

	-- previous output
	local loopy = promptY - MainFont:getHeight()
	for coloredtext in self.scrollback_out:iterator() do
		love.graphics.setColor(coloredtext[2])
		loopy = printMultiLine(coloredtext[1], self.charsPerLine, self.x, loopy) - MainFont:getHeight()
	end
	love.graphics.setColor(255,255,255,255)
	
	-- cursor
	love.graphics.print(self.cursor_char, self:_cursor_pixel_position(promptY))
end

return Terminal
