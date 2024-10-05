

local function NewBlock(world, blockDef, position)
	local self = {}
	self.pos = position
	self.def = blockDef
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
	end
	
	function self.Draw(drawQueue, selectedPoint, hoveredPoint, elementType)
		drawQueue:push({y=10; f=function()
			self.def.draw(self, drawQueue)
			love.graphics.setColor(1, 0, 1, 1)
			love.graphics.rectangle("line", self.pos[1] - self.def.width/2, self.pos[2] - self.def.height/2, self.def.width, self.def.height)
		end})
	end
	
	return self
end

return NewBlock