
local function GetFoodSize(self)
	local foodProp = self.maxFood and self.foodLeft/self.maxFood
	return foodProp and (0.4 + 0.6*foodProp) or 1
end

local function NewFoodSource(world, myDef, position, extraData)
	local self = {}
	self.pos = position
	self.def = myDef
	self.maxFood = (extraData and extraData.totalFood) or self.def.totalFood
	if self.maxFood and not self.def.placementLater then
		if self.def.foodType == "good" then
			self.maxFood = self.maxFood * (LevelHandler.GetLevelData().tweaks.foodHealthMult or 1)
		elseif self.def.foodType == "poison" then
			self.maxFood = self.maxFood * (LevelHandler.GetLevelData().tweaks.poisonHealthMult or 1)
		end
	end
	self.foodLeft = self.maxFood
	
	if self.def.blockerType then
		self.blocker = BlockHandler.SpawnBlock(self.def.blockerType, util.CopyTable(self.pos))
	end
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.CountImportantFood()
		return (not self.destroyed) and self.def.defeatAvoidingFoodValue
	end
	
	function self.AddFoodHealth()
		return self.foodLeft and (math.max(0, self.foodLeft) * self.def.defeatAvoidingFoodValue) or 0
	end
	
	function self.Destroy()
		if not self.destroyed then
			EffectsHandler.SpawnFadeEffect(
				self.def.image, self.pos, self.def.scale * GetFoodSize(self),
				self.def.rotation, self.def.drawLayer, self.def.fadeTime or 1, self.def.color)
		end
		self.destroyed = true
		if self.blocker then
			self.blocker.Destroy()
		end
	end
	
	function self.FoodTaken()
		if self.maxFood and not LevelHandler.GetEditMode() and not GameHandler.BlockHealthChanges() then
			self.foodLeft = self.foodLeft - 1
			if self.foodLeft <= 0 then
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
		if self.def.scentRadius then
			ScentHandler.AddScent("food", self.pos, self.def.scentRadius, dt*self.def.scentStrength)
		end
	end
	
	function self.ShiftPosition(vector)
		self.pos = util.Add(self.pos, vector)
	end
	
	function self.WriteSaveData()
		if self.def.ignoreSave then
			return false
		end
		return {self.def.name, self.pos, extraData}
	end
	
	function self.Draw(drawQueue)
		if not self.def.drawLayer then
			return
		end
		drawQueue:push({y=self.def.drawLayer; f=function()
			if self.def.image then
				DoodadHandler.DrawDoodad(self.def, self.pos, 1, GetFoodSize(self))
			else
				self.def.draw(self, drawQueue)
			end
			if foodProp and foodProp < 1 then
				InterfaceUtil.DrawBar(Global.HEALTH_BAR_COL, Global.HEALTH_BAR_BACK, foodProp, false, false, util.Add(self.pos, {-55, 30}), {110, 24})
			end
		end})
	end
	
	return self
end

return NewFoodSource