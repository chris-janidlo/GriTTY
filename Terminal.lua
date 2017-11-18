local GameObject = require 'GameObject'
local utf8 = require 'utf8'
local Signal = require 'hump.signal'

local Terminal = {}

GameObject:Register(Terminal)

-- returns the current input string split around the current cursor position
-- if trim is true, it trims the left hand side by one character before returning
function Terminal:split_at_cursor(trim)
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

function Terminal.cursor_pixel_position(self)
	local charwidth = MainFont:getWidth('C')
	local base = self.x + MainFont:getWidth(self.prompt) + charwidth / 2
	return base + charwidth * (#self.input + self.cursor_pos)
end

-------------------------------- LOVE CALLBACKS --------------------------------

function Terminal:load()
	love.keyboard.setKeyRepeat(true)

	-- position to print terminal line (including prompt)
	self.x = 5
	self.y = love.graphics.getHeight() - MainFont:getHeight() - 5
	
	self.prompt = '> '
	self.input = ''
	
	self.cursor_char = '|'
	self.cursor_pos = -1
end

-- basic text input
function Terminal:textinput(key)
	local l, r = self:split_at_cursor()
	self.input = l .. key .. r
end

-- handles special key codes (ie backspace, return, arrow keys)
function Terminal:keypressed(key)
	if key == "backspace" then
		local l, r = self:split_at_cursor(true)
		self.input = l .. r

	elseif key == "return" then
		Signal.emit('tty_text_input', self.input)
		self.input = ""
		self.cursor_pos = -1

	elseif key == "left" then
		-- cursor can, at most, be one to the left of the current input (when we want to insert at the beginning)
		self.cursor_pos = math.max(-#self.input - 1, self.cursor_pos - 1)

	elseif key == "right" then
		self.cursor_pos = math.min(self.cursor_pos + 1, -1)
	end
end

function Terminal:draw()
	love.graphics.print(self.prompt .. self.input, self.x, self.y)
	love.graphics.print(self.cursor_char, self:cursor_pixel_position(), self.y)
end
