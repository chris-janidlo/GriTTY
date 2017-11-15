local Vector = require 'hump.vector'
local Signal = require 'hump.signal'
local PointField = require 'StaticIntPointField'
local BidirectionalMap = require 'BidirectionalMap'
local CombatEntity = require 'CombatEntity'
local GameObject = require 'GameObject'
local commands = require 'BasePlayerCommands'

local CombatState = {}

GameObject:Register(CombatState)

function CombatState:load()
	self.player = CombatEntity('o', self)
	
	self.center = Vector.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	self.offset = MainFont:getHeight() -- height should always be greater than width, but we want a square, so use height as both height and width

	-- maps for objects and points
	-- only ever set in point-object order
	self.entities = BidirectionalMap() -- moving agents (player, enemies)
	self.projectiles = BidirectionalMap() -- things that interact on collision with entities (bullets, sword lines)
	self.particles = BidirectionalMap() -- purely visual effects go here

	-- the above maps all use the same playing field, which is:
	self.field = PointField.new(-16, 16, -16, 16)

	self.entities:set(self.field(0,0), self.player)
	self.entities:set(self.field(1,0), CombatEntity('p', self))
end

function CombatState:draw()
	for location,ent in pairs(self.entities._forward) do -- TODO: would love to use pairs(self.entities) but LOVE uses Lua 5.1 and __pairs was added in Lua 5.2
		love.graphics.print(
			{ ent.color, ent.indicator },
			location.x * self.offset + self.center.x,
			location.y * self.offset + self.center.y
		)
	end
end

Signal.register('tty_text_input', function(input)
	-- this is in a mock state. needs a dedicated toy parser for complex commands with arguments and things like command;command
	CombatState.player:action(commands[input])
end)

return CombatState
