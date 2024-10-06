
local data = {
	speed = 48,
	nestDist = 40,
	foodDist = 50,
	searchNestDist = 100,
	searchFoodDist = 100,
	feelerLength = 60,
	feelerAngle = 0.5,
	turnCheckLength = 5,
	turnCheckAngle = 0.7,
	lifetime = 800,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("ant_small", self.pos[1], self.pos[2], self.direction, 1, 6, {0.3, 0.3, 0.3})
		if self.hasFood == "poison" then
			Resources.DrawImage("green_ant", self.pos[1], self.pos[2], self.direction, 0.8, 1.4)
		elseif self.hasFood then
			Resources.DrawImage("blue_ant", self.pos[1], self.pos[2], self.direction, 0.8, 1.4)
		end
	end,
}

return data
