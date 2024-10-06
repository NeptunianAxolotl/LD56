

local function NewNest(world, myDef, position)
	local self = {}
	self.pos = position
	self.def = myDef
	self.foodLeft = self.def.totalFood
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.FoodTaken()
		if self.def.totalFood then
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
		ScentHandler.AddScent("food", self.pos, 120, dt*2)
	end
	
	function self.WriteSaveData()
		return {self.def.name, self.pos}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
			if self.def.totalFood then
				Font.SetSize(2)
				love.graphics.setColor(0, 0, 0, 0.5)
				love.graphics.print(self.foodLeft, self.pos[1] - 10, self.pos[2] + 40)
			end
		end})
	end
	
	return self
end

return NewNest