

local function NewNest(world, myDef, position)
	local self = {}
	self.pos = position
	self.def = myDef
	
	function self.Destroy()
		self.destroyed = true
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
		end})
	end
	
	return self
end

return NewNest