

local function NewNest(world, myDef, position, extraData)
	local self = {}
	self.pos = position
	self.def = myDef
	self.maxHealth = (extraData and extraData.health) or self.def.health
	self.health = self.maxHealth
	self.spawnTimer = 0
	
	if self.def.blockerType then
		self.blocker = BlockHandler.SpawnBlock(self.def.blockerType, util.CopyTable(self.pos))
	end
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.Destroy()
		self.destroyed = true
		if self.blocker then
			self.blocker.Destroy()
		end
	end
	
	function self.ApplyFood(foodType, foodValue)
		if foodType == "poison" then
			self.health = self.health - foodValue
			if self.health <= 0 then
				self.Destroy()
			end
		end
	end
	
	function self.HitTest(pos)
		return util.Dist(pos, self.pos) < 100
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		ScentHandler.AddScent("explore", self.pos, 120, dt*2)
		self.spawnTimer = self.spawnTimer + dt
		while self.spawnTimer > 1 / self.def.spawnFrequency do
			AntHandler.SpawnAnt(self.def.antType, self.pos)
			self.spawnTimer = self.spawnTimer - 1 / self.def.spawnFrequency
		end
	end
	
	function self.WriteSaveData()
		return {self.def.name, self.pos, extraData}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
			--Font.SetSize(2)
			--love.graphics.setColor(0.7, 0.8, 0.2, 0.5)
			--love.graphics.print("health " .. self.health, self.pos[1] - 80, self.pos[2])
			local healthProp = self.health/self.maxHealth
			if healthProp < 1 then
				InterfaceUtil.DrawBar(Global.HEALTH_BAR_COL, Global.HEALTH_BAR_BACK, healthProp, false, false, util.Add(self.pos, {-55, 30}), {110, 24})
			end
		end})
	end
	
	return self
end

return NewNest