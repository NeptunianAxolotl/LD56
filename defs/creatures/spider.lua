
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
	
	GetSpeedAndDirection = function (self, dt)
		local closestAnt = AntHandler.ClosestAnt(self.pos, 150)
		
		local directionChange = false
		if math.random() < 0.1 then
			directionChange = math.random()*26 - 13
		else
			directionChange = math.random()*3 - 1.5
		end
		if closestAnt then
			local toAnt = util.AngleFromPointToPoint(self.pos, closestAnt.pos)
			local angleDiff = util.AngleSubtractShortest(toAnt, self.direction)
			print(angleDiff)
			directionChange = directionChange + dt * angleDiff * 100
		end
		
		local speed = self.def.speed * self.speedMult * (self.accelMult or 1)
		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
		end
		return speed, directionChange
	end
}

return data
