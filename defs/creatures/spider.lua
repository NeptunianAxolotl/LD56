
local data = {
	speed = 65,
	turnCheckLength = 20,
	turnCheckAngle = 0.6,
	fearRadius = 90,
	pathingType = "ant",
	
	init = function (self)
		self.spiderStamina = 1
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
		print(self.spiderStamina)
     
        if self.waittimer and not closestAnt then 
            self.waittimer = self.waittimer - dt
            if self.waittimer < 0 then
                self.waittimer = false
            end

			self.spiderStamina = self.spiderStamina + dt*0.1
			if self.spiderStamina > 1 then
				self.spiderStamina = 1
			end

            return 0,0
        end
        
		self.movementtimer = (self.movementtimer or 0) + dt

		if self.movementtimer > 2 + math.random()*2 then
			self.movementtimer = 0
			self.waittimer = 1 + math.random()*3
		end

		local directionChange = false
		if math.random() < 0.1 then
			directionChange = math.random()*52 - 26
		else
			directionChange = math.random()*6 - 3
		end

		local chasespeed = 1

		if closestAnt then
			local toAnt = util.AngleFromPointToPointWithWrap(self.pos, closestAnt.pos)
			local angleDiff = util.AngleSubtractShortest(toAnt, self.direction)

			directionChange = directionChange + dt * angleDiff * 1000
			
			if antDist < 50 then
				chasespeed = 0
				closestAnt.Destroy()
			else
				chasespeed = 3
			end
		end

		if chasespeed > 1 then
			self.spiderStamina = self.spiderStamina - dt*0.1
		else
			self.spiderStamina = self.spiderStamina + dt*0.1
		end

		if self.spiderStamina < 0.1 then
			self.spiderStamina = 0
		end
		if self.spiderStamina > 1 then
			self.spiderStamina = 1
		end

		local speed = self.def.speed * self.speedMult * (self.accelMult or 1)
		local speed = speed*chasespeed*self.spiderStamina 

		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
		end
		return speed, directionChange
	end
}

return data
