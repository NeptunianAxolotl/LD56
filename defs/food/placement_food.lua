
local data = {
	foodType = "good",
	foodImage = "strawberry",
	foodValue = 1,
	totalFood = 10,
	scentRadius = 70,
	scentStrength = 0.8,
	closestDistScale = 0.5,
	defeatAvoidingFoodValue = 0,
	
	image = "strawberry",
	drawLayer = 60,
	scale = 0.1,
	placementLater = true,
	
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		Font.SetSize(2)
		love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
		love.graphics.print("Srawberry", self.pos[1] - 40, self.pos[2])
	end,
}

return data
