

local function NewNest(world, myDef, position, extraData)
	local self = {}
	self.pos = position
	self.def = myDef
	self.maxHealth = (extraData and extraData.health) or self.def.health
	if self.maxHealth and not self.def.placementLater then
		self.maxHealth = self.maxHealth * (LevelHandler.GetLevelData().tweaks.nestHealthMult or 1)
	end
	self.health = self.maxHealth
	self.spawnTimer = 0
	
	if self.def.blockerType then
		self.blocker = BlockHandler.SpawnBlock(self.def.blockerType, util.CopyTable(self.pos))
	end
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.CountNests()
		return (not self.destroyed) and self.def.victoryNestValue
	end
	
	function self.AddNestHealth()
		return math.max(0, self.health)
	end
	
	function self.Destroy()
		if not self.destroyed then
			EffectsHandler.SpawnFadeEffect(self.def.image, self.pos, self.def.scale, self.def.rotation, self.def.drawLayer, self.def.fadeTime or 1, self.def.color)
		end
		self.destroyed = true
		if self.blocker then
			self.blocker.Destroy()
		end
	end
	
	function self.ApplyFood(foodType, foodValue)
		if LevelHandler.GetEditMode() then
			return
		end
		if foodType == "poison" then
			self.health = self.health - foodValue
			if self.health <= 0 then
				self.Destroy()
			end
		elseif foodValue > 0 then
			self.spawnTimer = self.spawnTimer + foodValue / self.def.spawnFrequency
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
		self.spawnTimer = self.spawnTimer + dt * (LevelHandler.GetLevelData().tweaks.nestSpawnRate or 1)
		while self.spawnTimer > 1 / self.def.spawnFrequency do
			AntHandler.SpawnAnt(self.def.antType, self.pos)
			self.spawnTimer = self.spawnTimer - 1 / self.def.spawnFrequency
		end
	end
	
	function self.WriteSaveData()
		return {self.def.name, self.pos, extraData}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=self.def.drawLayer; f=function()
			if self.def.image then
				DoodadHandler.DrawDoodad(self.def, self.pos, 1)
			else
				self.def.draw(self, drawQueue)
			end
			local healthProp = self.health/self.maxHealth
			if healthProp < 1 then
				InterfaceUtil.DrawBar(Global.HEALTH_BAR_COL, Global.HEALTH_BAR_BACK, healthProp, false, false, util.Add(self.pos, {-55, 30}), {110, 24})
			end
		end})
	end
	
	return self
end

return NewNest