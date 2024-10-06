

local function NewCreature(world, creatureDef, position, size)
	local self = {}
	
	self.pos = position
	self.direction = math.random()*math.pi*2
	self.speedMult = math.random()*0.2 + 0.9
	self.stuckTime = false
	self.def = creatureDef
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.ApplyAirhorn(pos, radius, maxRadius)
		self.airhornEffect = 0.5 + (1 - radius / maxRadius)
		self.direction = util.Angle(util.Subtract(self.pos, pos)) + math.random() - 0.5
	end
	
	function self.ApplyAcceleration(pos, radius, maxRadius)
		self.accelMult = 5 + 3 * (1 - radius / maxRadius)
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		self.def.update(self, dt)
		
		local directionChange = false
		if math.random() < 0.1 then
			directionChange = math.random()*26 - 13
		else
			directionChange = math.random()*3 - 1.5
		end
		
		local speed = creatureDef.speed * self.speedMult * (self.accelMult or 1)
		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
		end
		
		self.direction = (self.direction + dt * directionChange)%(2*math.pi)
		local newPos = util.Add(self.pos, util.PolarToCart(speed * dt, self.direction))
		
		TerrainHandler.WrapPosInPlace(newPos)
		local blocked = BlockHandler.BlockAt(self.def.pathingType, newPos)
		local leftPos = util.Add(self.pos, util.PolarToCart(creatureDef.turnCheckLength, self.direction + creatureDef.turnCheckAngle))
		local rightPos = util.Add(self.pos, util.PolarToCart(creatureDef.turnCheckLength, self.direction - creatureDef.turnCheckAngle))
		local blockLeft = BlockHandler.BlockAt(self.def.pathingType, leftPos)
		local blockRight = BlockHandler.BlockAt(self.def.pathingType, rightPos)
		blocked = blocked or blockLeft or blockRight
		
		if blocked then
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
			if self.stuckTime > 1.5 then
				self.direction = self.direction + math.pi + math.random()*2 - 1
			end
			if self.stuckTime > 3 then
				self.pos[1] = self.pos[1] + (math.random() - 0.5) * self.stuckTime
				self.pos[2] = self.pos[2] + (math.random() - 0.5) * self.stuckTime
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
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
		end})
	end
	
	return self
end

return NewCreature
