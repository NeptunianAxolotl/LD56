

local function NewNest(world, position)
	local self = {}
	self.pos = position
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		ScentHandler.AddScent("food", self.pos, 140, dt*0.4)
	end
	
	function self.Draw(drawQueue, selectedPoint, hoveredPoint, elementType)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
		end})
	end
	
	return self
end

return NewNest