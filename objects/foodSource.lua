

local function NewNest(world, myDef, position, extraData)
	local self = {}
	self.pos = position
	self.def = myDef
	self.maxFood = (extraData and extraData.totalFood) or self.def.totalFood
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
		self.destroyed = true
		if self.blocker then
			self.blocker.Destroy()
		end
	end
	
	function self.FoodTaken()
		if self.maxFood and not LevelHandler.GetEditMode() then
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
		ScentHandler.AddScent("food", self.pos, self.def.scentRadius, dt*self.def.scentStrength)
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
			if self.maxFood then
				Font.SetSize(2)
				love.graphics.setColor(0, 0, 0, 0.5)
				love.graphics.print(self.foodLeft, self.pos[1] - 10, self.pos[2] + 40)
			end
		end})
	end
	
	return self
end

return NewNest