
local data = {
	speed = 65,
	turnCheckLength = 20,
	turnCheckAngle = 0.6,
	fearRadius = 90,
	pathingType = "ant",
	init = function (self)
	end,
	update = function (self, dt)
		local extraData = {dt = dt}
		AntHandler.DoFunctionToAntsInArea("ApplySpiderFear", self.pos, self.def.fearRadius, extraData)
	end,
	draw = function (self, drawQueue)
		Resources.DrawImage("spider", self.pos[1], self.pos[2], self.direction)
	end,
}

return data
