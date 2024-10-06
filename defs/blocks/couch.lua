
local data = {
	width = 300,
	height = 120,
	blockTypes = {"ant", "placement"},
	canBeMoved = true,
	
	image = "couch",
	drawLayer = 120,
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
