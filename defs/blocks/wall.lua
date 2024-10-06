
local data = {
	width = 40,
	height = 200,
	blockTypes = {"ant", "placement", "flying"},
	canBeMoved = false,
	init = function (self)
	end,
	update = function (self, dt)
	end,
	draw = function (self, drawQueue)
		love.graphics.setColor(0.4, 0.4, 0.4, 1)
		love.graphics.rectangle("fill", self.pos[1] - self.def.width/2, self.pos[2] - self.def.height/2, self.def.width, self.def.height)
	end,
}

return data
