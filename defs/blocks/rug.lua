
local data = {
	width = 300,
	height = 200,
	blockTypes = {"placement"},
	canBeMoved = false,
	
	image = "rug",
	drawLayer = 20,
	rotation = 0,
	flip = false,
	scale = 0.12,
	
	wantRotations = true,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
	end,
}

return data
