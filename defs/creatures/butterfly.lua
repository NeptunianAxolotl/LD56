
local data = {
	speed = 65,
	turnCheckLength = 20,
	turnCheckAngle = 0.6,
	
	pathingType = "flying",
	airhornMult = 2,
	drawLayer = 320,
	
	arriveDist = 30,
	
	mopRadius = 60,
	mopStrength = 3,
	
	enterGoalTime = 3,
	enterWanderTime = 20,
	
	flipTable = {-1, 1},
	init = function (self)
		self.homePos = util.CopyTable(self.pos)
		self.enterTimer = 0
		local levelData = LevelHandler.GetLevelData()
		self.enterGoal = {levelData.width / 2, levelData.height / 2}
	end,
	
	update = function (self, dt)
		ScentHandler.AddScent("explore", self.pos, self.def.mopRadius, -dt*self.def.mopStrength)
		ScentHandler.AddScent("food", self.pos, self.def.mopRadius, -dt*self.def.mopStrength)
	end,
	
	draw = function (self, drawQueue)
		if (self.direction + math.pi/2)%(math.pi*2) > math.pi then
			Resources.DrawImage("butterflyA", self.pos[1], self.pos[2], 0, 1, 1)
		else
			Resources.DrawImage("butterflyA", self.pos[1], self.pos[2], 0, 1, self.def.flipTable)
		end
	end,
	
	GetSpeedAndDirection = function (self, dt)
		local goal = false
		local goalStrength = 0
		if not self.airhornEffect then
			if self.leavingTimer then
				self.leavingTimer = self.leavingTimer + dt
				goal = self.homePos
				goalStrength = 1200 * (self.leavingTimer / (30 + self.leavingTimer ))
				if util.DistSq(self.pos, self.homePos) < self.def.arriveDist * self.def.arriveDist then
					self.Destroy()
				end
			elseif self.enterTimer then
				self.enterTimer = self.enterTimer + dt
				if self.enterTimer < self.def.enterGoalTime then
					goal = self.enterGoal
					goalStrength = 1200 * (1 - self.enterTimer / self.def.enterGoalTime)
				end
				if self.enterTimer > self.def.enterWanderTime then
					self.enterTimer = false
					self.leavingTimer = 0
				end
			end
		end
		
		local directionChange = false
		if math.random() < 0.1 then
			directionChange = math.random()*26 - 13
		else
			directionChange = math.random()*3 - 1.5
		end
		directionChange = directionChange * 5
		
		if goal then
			local toGoal = util.AngleFromPointToPoint(self.pos, goal)
			local angleDiff = util.AngleSubtractShortest(toGoal, self.direction)
			directionChange = directionChange + dt * angleDiff * goalStrength
		end
		
		local speed = self.def.speed * self.speedMult * (self.accelMult or 1)
		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4 * self.def.airhornMult)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
			self.pickupFoodTimer = false
		end
		return speed, directionChange
	end
}

return data
