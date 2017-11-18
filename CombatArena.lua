local Vector = require 'hump.vector'
local Signal = require 'hump.signal'
local PointField = require 'StaticIntPointField'
local BidirectionalMap = require 'BidirectionalMap'
local CombatEntity = require 'CombatEntity'
local CombatAgent = require 'CombatAgent'
local GameObject = require 'GameObject'
local commands = require 'BasePlayerCommands'

local CombatArena = {}

GameObject:Register(CombatArena)

function CombatArena:load()
	self.center = Vector.new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	self.offset = MainFont:getHeight() -- height should always be greater than width, but we want a square, so use height as both height and width
	
	-- maps for objects and entities
	-- only ever set in point-entity order
	self.agents = BidirectionalMap() -- moving agents (player, enemies)
	self.projectiles = BidirectionalMap() -- things that interact on collision with entities (bullets, sword lines)
	self.particles = BidirectionalMap() -- purely visual effects go here
	
	self.player = CombatAgent('o', PointField(0,0))

	self.agents:set(PointField(0,0), self.player)
	self.agents:set(PointField(1,0), CombatEntity('p', PointField(1,0)))
end

function CombatArena:drawEntityMap(map)
	for location,ent in map:iterator() do
		-- we draw at ent.location instead of location because it's the most up to date location we have. otherwise there's a stutter
		love.graphics.print(
			{ ent.color, ent.indicator },
			ent.location.x * self.offset + self.center.x,
			ent.location.y * self.offset + self.center.y
		)
	end
end

function CombatArena:draw()
	self:drawEntityMap(self.agents)
	self:drawEntityMap(self.projectiles)
	self:drawEntityMap(self.particles)
end

-- movement happens here
function CombatArena:updateEntityPositionsInMap(map)
	stuffToSet = {}
	for location,ent in map:iterator() do
		-- use stuffToSet so that we don't modify the table while iterating over it
		if ent.location ~= location then stuffToSet[ent.location] = ent end
	end
	for location,ent in pairs(stuffToSet) do
		if not map:get(location) then
			-- no collision; respect the location the entity is asking for
			map:set(location, ent)
		else
			-- there's a collision; fix the entity's location but keep the map location the same
			ent.location = map:get(ent)
		end
	end
end

function CombatArena:update(dt)
	self:updateEntityPositionsInMap(self.agents)
	self:updateEntityPositionsInMap(self.projectiles)
	self:updateEntityPositionsInMap(self.particles)
end

Signal.register('tty_text_input', function(input)
	-- this is in a mock state. needs a dedicated toy parser for complex commands with arguments and things like command;command
	CombatArena.player:action(commands[input])
end)

return CombatArena
