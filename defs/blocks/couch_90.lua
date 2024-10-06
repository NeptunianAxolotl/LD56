
local data = {
	width = 125,
	height = 300,
	drawLayer = 120,
	blockTypes = {"ant", "placement"},
	canBeMoved = true,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("couch", self.pos[1], self.pos[2], math.pi/2, 1, 0.12)
	end,
}

return data
