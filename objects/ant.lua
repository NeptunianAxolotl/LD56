

local function NewAnt(world, creatureDef, position, size)
	local self = {}
	
	self.pos = position
	self.direction = math.random()*math.pi*2
	self.def = creatureDef
	self.hasFood = false
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		self.def.update(self, dt)
		
		local directionChange = false
		if math.random() < 0.5 then
			local leftPos = util.Add(self.pos, util.PolarToCart(creatureDef.feelerLength, self.direction + creatureDef.feelerAngle))
			local rightPos = util.Add(self.pos, util.PolarToCart(creatureDef.feelerLength, self.direction - creatureDef.feelerAngle))
			TerrainHandler.WrapPosInPlace(leftPos)
			TerrainHandler.WrapPosInPlace(rightPos)
			
			local wantScent = self.hasFood and "explore" or "food"
			local leftScent = ScentHandler.GetScent(wantScent, leftPos)^2
			local rightScent = ScentHandler.GetScent(wantScent, rightPos)^2
			if leftScent > 0 or rightScent > 0 then
				local bias = 2*(leftScent / (leftScent + rightScent) - 0.5)
				directionChange = math.random()*2 - 1 + bias*3
				if math.random() < 0.1 then
					directionChange = 1*(math.random()*20 - 10)
				end
			end
		end
		if not directionChange then
			if math.random() < 0.1 then
				directionChange = math.random()*26 - 13
			else
				directionChange = math.random()*3 - 1.5
			end
		end
		self.direction = (self.direction + dt * directionChange)%(2*math.pi)
		
		self.pos = util.Add(self.pos, util.PolarToCart(dt * creatureDef.speed, self.direction))
		TerrainHandler.WrapPosInPlace(self.pos)
		
		if self.hasFood then
			ScentHandler.AddScent("food", self.pos, 30, dt)
		else
			ScentHandler.AddScent("explore", self.pos, 30, dt)
		end
		
		if math.random() < 0.1 then
			if self.hasFood and AntHandler.NearNest(self.pos, self.def.nestDist) then
				self.hasFood = false
				self.direction = self.direction + math.pi
			end
			if not self.hasFood and AntHandler.NearFoodSource(self.pos, self.def.foodDist) then
				self.hasFood = true
				self.direction = self.direction + math.pi
			end
		end
	end
	
	function self.Draw(drawQueue, selectedPoint, hoveredPoint, elementType)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
		end})
	end
	
	return self
end

return NewAnt
