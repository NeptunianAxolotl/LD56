

local function NewNest(world, myDef, position)
	local self = {}
	self.pos = position
	self.def = myDef
	self.foodLeft = self.def.totalFood
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.FoodTaken()
		self.foodLeft = self.foodLeft - 1
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		ScentHandler.AddScent("food", self.pos, 120, dt*2)
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
			Font.SetSize(2)
			love.graphics.setColor(0, 0, 0, 0.5)
			love.graphics.print(self.foodLeft, self.pos[1] - 10, self.pos[2] + 40)
		end})
	end
	
	return self
end

return NewNest