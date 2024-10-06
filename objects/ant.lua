

local function NewAnt(world, creatureDef, position, size)
	local self = {}
	
	self.pos = position
	self.direction = math.random()*math.pi*2
	self.def = creatureDef
	self.hasFood = false
	self.feelerOffset = math.random()*0.8 - 0.4
	self.speedMult = math.random()*0.2 + 0.9
	self.stuckTime = false
	self.spiderRunTime = false
	self.pickedUp = false
	self.life = self.def.lifetime
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.Destroy()
		if not self.destroyed then
			EffectsHandler.SpawnFadeEffect(self.def.image, self.pos, self.def.scale, self.direction, self.def.drawLayer, 0.4, self.def.color)
		end
		self.destroyed = true
	end
	
	function self.ApplyAirhorn(pos, radius, maxRadius)
		self.airhornEffect = 0.5 + (1 - radius / maxRadius)
		self.direction = util.AngleFromPointToPointWithWrap(pos, self.pos) + math.random() - 0.5
	end
	
	function self.ApplyAcceleration(pos, radius, maxRadius)
		self.accelMult = 5 + 3 * (1 - radius / maxRadius)
	end
	
	function self.ApplySpiderFear(pos, radius, maxRadius, extraData)
		self.accelMult = (self.accelMult or 1) + extraData.dt * 2 * (1 - radius / maxRadius)
		self.spiderRunTime = 1.5
		self.direction = util.AngleFromPointToPointWithWrap(pos, self.pos) + (math.random() - 0.5)*0.2
	end
	
	function self.SetPickedUp()
		self.pickedUp = true
		if self.hasFood == "poison" then
			self.hasFood = false -- Manually ferrying ants would be a boring way to win
		end
	end
	
	function self.DropAt(pos)
		self.pos = pos
		TerrainHandler.WrapPosInPlace(self.pos)
		self.pickedUp = false
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		self.def.update(self, dt)
		if self.pickedUp then
			self.pos = world.GetMousePosition()
			return
		end
		if world.GetGameOver() then
			self.fadeRate = self.fadeRate or 0.5 + 4*math.random()
			self.life = math.min(2, self.life) - dt * self.fadeRate
		else
			self.life = self.life - dt * LevelHandler.GetLifeRateMultiplier()
		end
		if self.life < 0 then
			self.Destroy()
			return true
		end
		
		local directionChange = false
		if math.random() < 0.4 then
			local leftPos = util.Add(self.pos, util.PolarToCart(creatureDef.feelerLength, self.direction + creatureDef.feelerAngle + self.feelerOffset))
			local rightPos = util.Add(self.pos, util.PolarToCart(creatureDef.feelerLength, self.direction - creatureDef.feelerAngle + self.feelerOffset))
			TerrainHandler.WrapPosInPlace(leftPos)
			TerrainHandler.WrapPosInPlace(rightPos)
			
			local wantScent = self.hasFood and "explore" or "food"
			local leftScent = (ScentHandler.GetScent(wantScent, leftPos, true) + 0.1)^2
			local rightScent = (ScentHandler.GetScent(wantScent, rightPos, true) + 0.1)^2
			local totalScent = (leftScent + rightScent)
			local bias = 2*(leftScent / totalScent - 0.5)
			directionChange = math.random()*2 - 1 + bias*(2 + 8*(totalScent / (600 + totalScent)))
			if math.random() < 0.1 then
				directionChange = 1*(math.random()*20 - 10)
			end
		else
			if math.random() < 0.1 then
				directionChange = math.random()*26 - 13
			else
				directionChange = math.random()*3 - 1.5
			end
		end
		
		local speed = creatureDef.speed * self.speedMult * (self.accelMult or 1)
		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
		end
		if self.spiderRunTime then
			speed = speed * 2
		end
		
		self.direction = (self.direction + dt * directionChange)%(2*math.pi)
		local newPos = util.Add(self.pos, util.PolarToCart(speed * dt, self.direction))
		
		TerrainHandler.WrapPosInPlace(newPos)
		if BlockHandler.BlockAt("ant", newPos) then
			local leftPos = util.Add(self.pos, util.PolarToCart(creatureDef.turnCheckLength, self.direction + creatureDef.turnCheckAngle))
			local rightPos = util.Add(self.pos, util.PolarToCart(creatureDef.turnCheckLength, self.direction - creatureDef.turnCheckAngle))
			local blockLeft = BlockHandler.BlockAt("ant", leftPos)
			local blockRight = BlockHandler.BlockAt("ant", rightPos)
			if blockLeft ~= blockRight then
				if blockLeft then
					self.direction = self.direction - math.random()
				else
					self.direction = self.direction + math.random()
				end
			else
				self.direction = self.direction + math.random() - 0.5
			end
			self.stuckTime = (self.stuckTime or 0) + dt
			if self.stuckTime > 1 then
				self.direction = self.direction + math.pi + math.random()*2 - 1
			end
			if self.stuckTime > 1.5 then
				self.pos[1] = self.pos[1] + (math.random() - 0.5) * self.stuckTime * 5
				self.pos[2] = self.pos[2] + (math.random() - 0.5) * self.stuckTime * 5
				TerrainHandler.WrapPosInPlace(self.pos)
			end
		else
			self.pos = newPos
			self.stuckTime = false
		end
		
		if self.accelMult then
			self.accelMult = self.accelMult - dt*0.6
			if self.accelMult < 1 then
				self.accelMult = false
			end
		end
		
		if self.airhornEffect then
			self.airhornEffect = self.airhornEffect - dt
			if self.airhornEffect < 0 then
				self.airhornEffect = false
			end
		end
		
		if self.spiderRunTime then
			self.spiderRunTime = self.spiderRunTime - dt
			if self.spiderRunTime < 0 then
				self.spiderRunTime = false
			end
		end
		
		if self.hasFood then
			ScentHandler.AddScent("food", self.pos, 36, dt*1.5)
		else
			ScentHandler.AddScent("explore", self.pos, 30, dt)
		end
		
		if math.random() < 0.1 then
			if self.hasFood then
				local nearNest, nestDist = AntHandler.NearNest(self.pos, self.def.searchNestDist)
				if nearNest then
					if nestDist < self.def.nestDist then
						nearNest.ApplyFood(self.hasFood, self.foodValue)
						self.hasFood = false
						self.direction = self.direction + math.pi
					else
						self.direction = util.AngleFromPointToPointWithWrap(self.pos, nearNest.pos)
					end
				end
			end
			if not self.hasFood then
				local nearFood, foodDist = AntHandler.NearFoodSource(self.pos, self.def.searchNestDist)
				if nearFood then
					if foodDist < self.def.foodDist then
						nearFood.FoodTaken()
						self.hasFood = nearFood.def.foodType
						self.foodValue = nearFood.def.foodValue
						self.direction = self.direction + math.pi
					else
						self.direction = util.AngleFromPointToPointWithWrap(self.pos, nearFood.pos)
					end
				end
			end
		end
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=self.def.drawLayer; f=function()
			self.def.draw(self, drawQueue)
		end})
	end
	
	return self
end

return NewAnt
