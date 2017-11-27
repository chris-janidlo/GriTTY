local ChoiceEntity = require 'ChoiceEntity'
local CT = require 'DataStructures.ChoiceTree'
local Point = require 'DataStructures.StaticIntPointField'

local circleAction = {
	{
		function(rudy) rudy.location = Point(-rudy.location.y, rudy.location.x) end,
		.35
	}
}


local behavior = CT.Leaf(circleAction)

return function()
	rudy = ChoiceEntity('r', Point(1,0), behavior)
	rudy:setColor(255,0,0)
	return rudy
end
