
local data = {
	speed = 60,
	nestDist = 80,
	foodDist = 80,
	feelerLength = 36,
	feelerAngle = 0.5,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("basic_ant", self.pos[1], self.pos[2], self.direction)
	end,
}

return data
