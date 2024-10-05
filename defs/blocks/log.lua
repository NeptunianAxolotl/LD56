
local data = {
	width = 90,
	height = 235,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("log", self.pos[1], self.pos[2])
	end,
}

return data
