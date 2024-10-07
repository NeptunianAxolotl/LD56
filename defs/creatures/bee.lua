
local data = {
	speed = 110,
	turnCheckLength = 20,
	turnCheckAngle = 0.6,
	
	pathingType = "flying",
	airhornMult = 2,
	drawLayer = 320,
	
	pickDist = 80,
	pickTime = 0.8,
	arriveDist = 30,
	
	scentRadius = 45,
	scentStrength = 40,
	
	flipTable = {-1, 1},
	init = function (self)
		self.SetHomePosition(self.pos)
	end,
	
	update = function (self, dt)
		if self.hasFood then
			ScentHandler.AddScent("food", self.pos, self.def.scentRadius, dt*self.def.scentStrength)
		end
	end,
	
	draw = function (self, drawQueue)
		if (self.direction + math.pi/2)%(math.pi*2) > math.pi then
			Resources.DrawImage("bee", self.pos[1], self.pos[2], 0, 1, 1)
		else
			Resources.DrawImage("bee", self.pos[1], self.pos[2], 0, 1, self.def.flipTable)
		end
	end,
	
	GetSpeedAndDirection = function (self, dt)
		local goal = false
		if not self.airhornEffect then
			if self.hasFood then
				goal = self.homePos
				if util.DistSq(self.pos, self.homePos) < self.def.arriveDist * self.def.arriveDist then
					self.Destroy()
				end
			elseif self.pickupFoodTimer then
				self.pickupFoodTimer = self.pickupFoodTimer - dt
				if self.pickupFoodTimer < 0 then
					self.pickupFoodTimer = false
					local closestFood, foodDist = AntHandler.GetClosestNonPoisonFoodNoWrap(self.pos)
					if foodDist and foodDist < self.def.pickDist then
						self.hasFood = true
					end
				end
				return 0, 0
			else
				local closestFood, foodDist = AntHandler.GetClosestNonPoisonFoodNoWrap(self.pos)
				if foodDist and foodDist < self.def.pickDist then
					self.pickupFoodTimer = self.def.pickTime
				elseif closestFood then
					goal = closestFood.pos
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
			directionChange = directionChange + dt * angleDiff * 80
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
