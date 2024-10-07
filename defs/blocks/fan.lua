
local data = {
	width = 80,
	height = 70,
	blockTypes = {"placement", "ant"},
	canBeMoved = true,
	
	pushWidth = 160,
	pushHeight = 420,
	pushOffsetX = 0,
	pushOffsetY = 200,
	fanStrength = 15,
	fanCardinalDirection = 0,
	
	image = "fan_a",
	image2 = "fan_b",
	drawLayer = 160,
	rotation = 0,
	flip = false,
	scale = 0.055,
	wantRotations = true,
	
	init = function (self)
	end,
	update = function (self, dt)
		self.fanAnim = ((self.fanAnim or 0) + dt*2.8)%1
	end,
	draw = function (self, drawQueue)
	end,
}

return data
