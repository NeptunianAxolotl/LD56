
local data = {
	foodType = "poison",
	foodImage = "poison",
	foodValue = 1,
	totalFood = 40,
	scentRadius = 100,
	scentStrength = 1.8,
	closestDistScale = 0.9,
	blockerType = "placement_blocker_ignore_save",
	defeatAvoidingFoodValue = 0,
	
	image = "poison_pile",
	drawLayer = 60,
	scale = 0.07,
	
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
	end,
}

return data
