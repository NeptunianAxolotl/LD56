
local data = {
	width = 100,
	height = 200,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("log", self.pos[1], self.pos[2])
	end,
}

return data
