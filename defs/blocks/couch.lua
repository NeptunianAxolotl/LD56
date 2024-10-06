
local data = {
	width = 300,
	height = 125,
	drawLayer = 120,
	blockTypes = {"ant", "placement"},
	canBeMoved = true,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("couch", self.pos[1], self.pos[2], 0, 1, 0.12)
	end,
}

return data
