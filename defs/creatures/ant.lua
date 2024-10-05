
local data = {
	speed = 60,
	nestDist = 60,
	foodDist = 60,
	feelerLength = 60,
	feelerAngle = 0.5,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("basic_ant", self.pos[1], self.pos[2], self.direction)
		if self.hasFood then
			Resources.DrawImage("blue_ant", self.pos[1], self.pos[2], self.direction, 0.7, 1.3)
		end
	end,
}

return data
