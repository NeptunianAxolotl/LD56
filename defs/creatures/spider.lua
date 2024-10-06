
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
	airhornMult = 2,
	drawLayer = 120,
	
	init = function (self)
		self.spiderStamina = 1
	end,
	
	update = function (self, dt)
		local extraData = {dt = dt}
		AntHandler.DoFunctionToAntsInArea("ApplySpiderFear", self.pos, self.def.fearRadius, extraData)
	end,
	
	draw = function (self, drawQueue)
		--Resources.DrawImage("spider_small", self.pos[1], self.pos[2], self.direction, 1, 6.6666666*5)
		local spider_scale = 1.4
		Resources.DrawImage("spider_leg_L1", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_leg_L2", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_leg_L3", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_leg_L4", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_leg_R1", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_leg_R2", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_leg_R3", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_leg_R4", self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_body", 	self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_head", 	self.pos[1], self.pos[2], self.direction, 1, spider_scale)
	end,
	
	GetSpeedAndDirection = function (self, dt)
		local closestAnt, antDist = AntHandler.ClosestAnt(self.pos, self.def.antSearchRadius)
		
		self.wanderDirection = (self.wanderDirection or 0) + dt*(math.random()*40 - 20)
		self.wanderDirection = math.max(-1, math.min(1, self.wanderDirection))
		
		if self.waittimer and not self.airhornEffect and not self.accelMult then 
			self.waittimer = self.waittimer - dt
            if self.waittimer < 0 then
                self.waittimer = false
            end

			self.spiderStamina = self.spiderStamina + dt*self.def.staminaRecharge*3
			if self.spiderStamina > 1 then
				self.spiderStamina = 1
			end

            return 0, self.wanderDirection*0.4 + math.random()*0.2 - 0.1
        end
        
		self.movementtimer = (self.movementtimer or 2) - dt
		if self.movementtimer < 0 and not closestAnt then
			self.movementtimer = (3 + math.random()*3) * self.def.movePeriodMult
			self.waittimer = (1 + math.random()) * self.def.waitPeriodMult
		end

		local directionChange = false
		if math.random() < 0.02 then
			directionChange = self.wanderDirection * (math.random()*10 - 2)
		else
			directionChange = self.wanderDirection + math.random()*4 - 2
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
		local speed = speed*chasespeed*(0.3 + 0.7*self.spiderStamina)
		if self.spiderStamina < 0.3 then
			self.waittimer = (1 + math.random()*2) * self.def.waitPeriodMult * 2
		end

		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4 * self.def.airhornMult)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
		end
		return speed, directionChange
	end
}

return data
