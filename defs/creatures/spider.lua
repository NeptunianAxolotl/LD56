
local data = {
	speed = 65,
	turnCheckLength = 20,
	turnCheckAngle = 0.6,
	fearRadius = 90,
	antSearchRadius = 150,
	movePeriodMult = 1,
	waitPeriodMult = 1,
	staminaRecharge = 0.3,
	staminaSpend = 0.15,
	pathingType = "ant",
	
	init = function (self)
		self.spiderStamina = 1
	end,
	
	update = function (self, dt)
		local extraData = {dt = dt}
		AntHandler.DoFunctionToAntsInArea("ApplySpiderFear", self.pos, self.def.fearRadius, extraData)
	end,
	
	draw = function (self, drawQueue)
		Resources.DrawImage("spider_small", self.pos[1], self.pos[2], self.direction, 1, 6.6666666*5)
	end,
	
	GetSpeedAndDirection = function (self, dt)
		local closestAnt, antDist = AntHandler.ClosestAnt(self.pos, self.def.antSearchRadius)
		
		if self.waittimer and not closestAnt and not self.airhornEffect and not self.accelMult then 
			self.waittimer = self.waittimer - dt
            if self.waittimer < 0 then
                self.waittimer = false
            end

			self.spiderStamina = self.spiderStamina + dt*self.def.staminaRecharge*3
			if self.spiderStamina > 1 then
				self.spiderStamina = 1
			end

            return 0,0
        end
        
		self.movementtimer = (self.movementtimer or 2) - dt
		if self.movementtimer < 0 then
			self.movementtimer = (2 + math.random()*2) * self.def.movePeriodMult
			self.waittimer = (1 + math.random()) * self.waitPeriodMult
		end

		local directionChange = false
		if math.random() < 0.1 then
			directionChange = math.random()*52 - 26
		else
			directionChange = math.random()*6 - 3
		end

		local chasespeed = 1

		if closestAnt and not self.airhornEffect then
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
			self.spiderStamina = self.spiderStamina - dt*self.def.staminaSpend
		else
			self.spiderStamina = self.spiderStamina + dt*self.def.staminaRecharge
		end

		if self.spiderStamina < 0.1 then
			self.spiderStamina = 0
		end
		if self.spiderStamina > 1 then
			self.spiderStamina = 1
		end

		local speed = self.def.speed * self.speedMult * (self.accelMult or 1)
		local speed = speed*chasespeed*self.spiderStamina
		if self.spiderStamina < 0.1 then
			self.waittimer = (1 + math.random()*2) * self.waitPeriodMult * 2
		end

		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
		end
		return speed, directionChange
	end
}

return data
