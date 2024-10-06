
local data = {
	width = 80,
	height = 70,
	blockTypes = {"placement", "ant"},
	canBeMoved = true,
	
	pushWidth = 140,
	pushHeight = 380,
	pushOffsetX = 0,
	pushOffsetY = 175,
	fanStrength = 15,
	fanCardinalDirection = 0,
	
	image = "fan",
	drawLayer = 160,
	rotation = 0,
	flip = false,
	scale = 0.055,
	wantRotations = true,
	
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
	end,
}

return data
