
local data = {
	foodType = "poison",
	foodImage = "poison",
	foodValue = 1,
	scentRadius = 120,
	scentStrength = 1.8,
	closestDistScale = 1,
	totalFood = false,
	blockerType = "placement_blocker_ignore_save",
	defeatAvoidingFoodValue = 0,
	
	image = "poison_pile",
	drawLayer = 60,
	scale = 0.1,
	
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
	end,
}

return data
