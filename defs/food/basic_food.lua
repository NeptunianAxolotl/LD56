
local data = {
	foodType = "good",
	foodImage = "cheese",
	foodValue = 1,
	totalFood = 80,
	scentRadius = 100,
	scentStrength = 1.5,
	closestDistScale = 0.8,
	blockerType = "placement_blocker_ignore_save",
	defeatAvoidingFoodValue = 1,
	
	image = "cheese",
	drawLayer = 60,
	scale = 0.1,

	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Font.SetSize(2)
		love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
		love.graphics.print("Cake", self.pos[1] - 40, self.pos[2])
	end,
}

return data
