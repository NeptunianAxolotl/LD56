
local data = {
	foodType = "good",
	foodValue = 1,
	totalFood = 50,
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
