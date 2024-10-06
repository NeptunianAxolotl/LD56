
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
	drawLayer = 100,
	
	image = "ant_small",
	scale = 6,
	color = {0.3, 0.3, 0.3},
	
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		local alpha = ((self.stuckTime or 0) > 0.5 and math.max(0.06, (1 - (self.stuckTime - 0.5)*6))) or 1
		Resources.DrawImage(self.def.image, self.pos[1], self.pos[2], self.direction, alpha, self.def.scale, self.def.color)
		if self.hasFood == "poison" then
			Resources.DrawImage("green_ant", self.pos[1], self.pos[2], self.direction, 0.8*alpha, 1.4)
		elseif self.hasFood then
			Resources.DrawImage("blue_ant", self.pos[1], self.pos[2], self.direction, 0.8*alpha, 1.4)
		end
	end,
}

return data
