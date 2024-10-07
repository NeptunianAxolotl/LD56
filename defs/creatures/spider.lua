
local data = {
	speed = 65,
	turnCheckLength = 20,
	turnCheckAngle = 0.6,
	fearRadius = 90,
	antSearchRadius = 150,
	movePeriodMult = 1,
	waitPeriodMult = 1,
	staminaRecharge = 0.3,
	staminaSpend = 0.12,
	pathingType = "ant",
	airhornMult = 2,
	drawLayer = 120,
	
	init = function (self)
		self.spiderStamina = 1
	end,
	
	update = function (self, dt)
		local extraData = {dt = dt}
		AntHandler.DoFunctionToAntsInArea("ApplySpiderFear", self.pos, self.def.fearRadius, extraData)

		local walkconstant = 0.2
		local stepangle = 0.2

		local offset_leg1 = math.pi*(1/8) --1
		local offset_leg2 = math.pi*(5/8) --5
		local offset_leg3 = math.pi*(3/8) --3
		local offset_leg4 = math.pi*(7/8) --7
		
		local offset_leg5 = math.pi*(4/8) --4
		local offset_leg6 = math.pi*(6/8) --6
		local offset_leg7 = math.pi*(2/8) --2
		local offset_leg8 = math.pi*(8/8) --8

		self.walktimer1 = ((self.walktimer1 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg1)
		self.walkangle1 = (math.sin(self.walktimer1) + math.sin((3 * self.walktimer1))/9 )*stepangle

		self.walktimer2 = ((self.walktimer2 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg2)
		self.walkangle2 = (math.sin(self.walktimer2) + math.sin((3 * self.walktimer2))/9 )*stepangle

		self.walktimer3 = ((self.walktimer3 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg3)
		self.walkangle3 = (math.sin(self.walktimer3) + math.sin((3 * self.walktimer3))/9 )*stepangle

		self.walktimer4 = ((self.walktimer4 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg4)
		self.walkangle4 = (math.sin(self.walktimer4) + math.sin((3 * self.walktimer4))/9 )*stepangle

		self.walktimer5 = ((self.walktimer5 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg5)
		self.walkangle5 = (math.sin(self.walktimer5) + math.sin((3 * self.walktimer5))/9 )*stepangle

		self.walktimer6 = ((self.walktimer6 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg6)
		self.walkangle6 = (math.sin(self.walktimer6) + math.sin((3 * self.walktimer6))/9 )*stepangle

		self.walktimer7 = ((self.walktimer7 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg7)
		self.walkangle7 = (math.sin(self.walktimer7) + math.sin((3 * self.walktimer7))/9 )*stepangle

		self.walktimer8 = ((self.walktimer8 or 0) + walkconstant*dt*(self.lastSpeed or 0)) % (math.pi *2 + offset_leg8)
		self.walkangle8 = (math.sin(self.walktimer8) + math.sin((3 * self.walktimer8))/9 )*stepangle
	end,
	
	draw = function (self, drawQueue)
		--Resources.DrawImage("spider_small", self.pos[1], self.pos[2], self.direction, 1, 6.6666666*5)
		local spider_scale = 1.4
		Resources.DrawImage("spider_leg_1", self.pos[1], self.pos[2], self.direction+self.walkangle1, 1, spider_scale)
		Resources.DrawImage("spider_leg_2", self.pos[1], self.pos[2], self.direction+self.walkangle2, 1, spider_scale)
		Resources.DrawImage("spider_leg_3", self.pos[1], self.pos[2], self.direction+self.walkangle3, 1, spider_scale)
		Resources.DrawImage("spider_leg_4", self.pos[1], self.pos[2], self.direction+self.walkangle4, 1, spider_scale)
		Resources.DrawImage("spider_leg_right_1", self.pos[1], self.pos[2], self.direction+self.walkangle5, 1, spider_scale)
		Resources.DrawImage("spider_leg_right_2", self.pos[1], self.pos[2], self.direction+self.walkangle6, 1, spider_scale)
		Resources.DrawImage("spider_leg_right_3", self.pos[1], self.pos[2], self.direction+self.walkangle7, 1, spider_scale)
		Resources.DrawImage("spider_leg_right_4", self.pos[1], self.pos[2], self.direction+self.walkangle8, 1, spider_scale)
		Resources.DrawImage("spider_body", 	self.pos[1], self.pos[2], self.direction, 1, spider_scale)
		Resources.DrawImage("spider_head", 	self.pos[1], self.pos[2], self.direction, 1, spider_scale)
	end,
	
	GetSpeedAndDirection = function (self, dt)
		local activityMult = (LevelHandler.GetLevelData().tweaks.spiderActivityMult or 1)
		local searchMult = (LevelHandler.GetLevelData().tweaks.spiderSearchMult or 1)
		
		local closestAnt, antDist = AntHandler.ClosestAntNoStuck(self.pos, self.def.antSearchRadius * searchMult)
		
		self.wanderDirection = (self.wanderDirection or 0) + dt*(math.random()*40 - 20)
		self.wanderDirection = math.max(-1, math.min(1, self.wanderDirection))
		
		if self.waittimer and not self.airhornEffect and not self.accelMult then 
			self.waittimer = self.waittimer - dt*activityMult
            if self.waittimer < 0 then
                self.waittimer = false
            end

			self.spiderStamina = self.spiderStamina + dt*self.def.staminaRecharge*3
			if self.spiderStamina > 1 then
				self.spiderStamina = 1
			end

            return 0, 0
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
			self.spiderStamina = self.spiderStamina - dt*self.def.staminaSpend / activityMult
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
