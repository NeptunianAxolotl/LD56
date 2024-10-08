
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
	scale = 0.6,
	color = {0.3, 0.3, 0.3},
	
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		local alpha = ((self.stuckTime or 0) > 0.5 and math.max(0.06, (1 - (self.stuckTime - 0.5)*6))) or 1
		if self.life and self.fadeRate then
			alpha = alpha * self.life / Global.WIN_FADE_TIME
		end
		Resources.DrawImage(self.def.image, self.pos[1], self.pos[2], self.direction, alpha, self.def.scale, self.def.color)
		if self.hasFood and self.foodImage then
			local foodPos = util.Add(self.pos, util.PolarToCart(15, self.direction))
			Resources.DrawImage(self.foodImage, foodPos[1], foodPos[2], self.direction, alpha, 0.02)
		end
	end,
}

return data
