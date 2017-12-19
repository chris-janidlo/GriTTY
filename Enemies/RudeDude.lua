local ChoiceEntity = require 'ChoiceEntity'
local CT = require 'DataStructures.ChoiceTree'
local Point = require 'DataStructures.StaticIntPointField'

local circleAction = function(terminal, rudy, wait)
	rudy.location = Point(-rudy.location.y, rudy.location.x) 
	wait(.35)
end


local behavior = CT.Leaf(circleAction)

return function()
	rudy = ChoiceEntity('r', Point(1,0), behavior)
	rudy:setColor(255,0,0)
	return rudy
end
