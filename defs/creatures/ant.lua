
local data = {
	speed = 60,
	radius = 10,
	nestDist = 50,
	foodDist = 50,
	feelerLength = 60,
	searchNestDist = 100,
	searchFoodDist = 100,
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
