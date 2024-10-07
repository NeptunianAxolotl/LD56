
local data = {
	spawnFrequency = 6,
	antType = "ant",
	health = 50,
	blockerType = "placement_blocker_ignore_save",
	victoryNestValue = 1,
	
	image = "antsnest",
	drawLayer = 35,
	scale = 0.1,
	fadeTime = 1.4,
	
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
	end,
}

return data
