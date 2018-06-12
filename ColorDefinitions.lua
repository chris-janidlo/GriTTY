-- define all colors in a central location for
	-- refactoring
	-- accessibility


-- basic 'palette'
local colors = {
	red = {255, 0, 0},
	white = {255, 255, 255},
	niceBlue = {170, 170, 255},
	harmlessOrange = {254, 137, 17}
}

colors.errorMessage = colors.red
	
colors.playerActing = colors.niceBlue
colors.enemyAttacking = colors.red

return colors
