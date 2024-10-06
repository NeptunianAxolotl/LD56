
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
		local closestAnt, antDist = AntHandler.ClosestAnt(self.pos, 150)
     
        if self.waittimer and not closestAnt then 
            self.waittimer = self.waittimer - dt
            if self.waittimer < 0 then
                self.waittimer = false
            end
            return 0,0
        end
        
		self.movementtimer = (self.movementtimer or 0) + dt

		if self.movementtimer > 2 + math.random()*2 then
			self.movementtimer = 0
			self.waittimer = 1 + math.random()*3
		end

		--directionChange = math.random()*26 - 13
		--directionChange = math.random()*3 - 1.5

		local directionChange = false
		if math.random() < 0.1 then
			directionChange = math.random()*52 - 26
		else
			directionChange = math.random()*6 - 3
		end

		local chasespeed = 1

		if closestAnt then
			local toAnt = util.AngleFromPointToPoint(self.pos, closestAnt.pos)
			local angleDiff = util.AngleSubtractShortest(toAnt, self.direction)
			print(angleDiff)
			directionChange = directionChange + dt * angleDiff * 1000
			
			if antDist < 50 then
				chasespeed = 0
				closestAnt.Destroy()
			else
				chasespeed = 3
			end
		end


		local speed = self.def.speed * self.speedMult * (self.accelMult or 1)
		local speed = speed*chasespeed

		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
		end
		return speed, directionChange
	end
}

return data
