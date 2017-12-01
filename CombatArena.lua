local Signal = require 'hump.signal'
local PointField = require 'DataStructures.StaticIntPointField'
local BidirectionalMap = require 'DataStructures.BidirectionalMap'
local CombatEntity = require 'CombatEntity'
local PlayerEntity = require 'PlayerEntity'
local Vector = require 'hump.vector'
local rudy = require 'Enemies.RudeDude'

local CombatArena = {}

function CombatArena:initialize(max_x, max_y) -- possible ranges will be -max to max
	self.size = Vector(max_x, max_y) * 2 + Vector(1,1)
	self.offset = MainFont:getHeight() -- height should always be greater than width, but we want square cells, so use height as both height and width


	self.rectDimensions = (self.size + Vector(1,1)) * self.offset -- rectangle is one char greater than the arena
	self.rectLocation = Vector(self.offset / 2, love.graphics.getHeight() - self.rectDimensions.y - self.offset / 2)

	self.center = self.rectLocation + self.rectDimensions / 2
	
	-- maps for objects and entities
	-- don't set directly; use self:spawn
	self.agents = BidirectionalMap() -- moving agents (player, enemies)
	self.projectiles = BidirectionalMap() -- things that interact on collision with entities (bullets, sword lines)
	self.particles = BidirectionalMap() -- purely visual effects go here
	
	Player = PlayerEntity('o', PointField(0,0))

	self:Spawn(Player, 'agents')

	self:Spawn(rudy(), 'agents')
end

-- entityMap is a string that must be set to one of 'agents', 'projectiles', or 'particles'
-- returns true if successful, false if not (entity/location already exists)
function CombatArena:Spawn(entity, entityMap)
	assert(type(entityMap) == 'string', 'entityMap must be a string')
	assert(
		entityMap == 'agents' or entityMap == 'projectiles' or entityMap == 'particles',
		'given string "'..entityMap..'" is not a valid entity map'
	)
	local map = self[entityMap]
	if not map:get(entity) and not map:get(entity.location) then
		map:set(entity.location, entity)
		return true
	end
	return false
end

function CombatArena:drawEntityMap(map)
	for location,ent in map:iterator() do
		-- we draw at ent.location instead of location because it's the most up to date location we have. otherwise there's a stutter
		love.graphics.print(
			{ ent.color, ent.indicator },
			ent.location.x * self.offset + self.center.x - self.offset / 2, -- draw at the center of the char instead of the top left
			ent.location.y * self.offset + self.center.y - self.offset / 2
		)
	end
end

function CombatArena:draw()
	love.graphics.rectangle("line", self.rectLocation.x, self.rectLocation.y, self.rectDimensions.x, self.rectDimensions.y)
	self:drawEntityMap(self.agents)
	self:drawEntityMap(self.projectiles)
	self:drawEntityMap(self.particles)
end

function CombatArena:inBounds(location)
	local bounds = (self.size - Vector(1,1)) / 2
	return math.abs(location.x) <= bounds.x and math.abs(location.y) <= bounds.y
end

-- movement happens here
function CombatArena:updateEntityPositionsInMap(map)
	stuffToSet = {}
	for location,ent in map:iterator() do
		-- use stuffToSet so that we don't modify the table while iterating over it
		if ent.location ~= location then stuffToSet[ent.location] = ent end
	end
	for location,ent in pairs(stuffToSet) do
		if self:inBounds(location) and not map:get(location) then
			-- respect the location the entity is asking for
			map:set(location, ent)
		else
			-- fix the entity's location but keep the map location the same
			ent.location = map:get(ent)
		end
	end
end

function CombatArena:update(dt)
	self:updateEntityPositionsInMap(self.agents)
	self:updateEntityPositionsInMap(self.projectiles)
	self:updateEntityPositionsInMap(self.particles)
	self.agents:callAll('update', dt)
end

return CombatArena
