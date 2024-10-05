

local function NewAnt(world, creatureDef, position, size)
	local self = {}
	
	self.pos = position
	self.direction = math.random()*math.pi*2
	self.def = creatureDef
	self.hasFood = false
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		self.def.update(self, dt)
		self.pos = util.Add(self.pos, util.PolarToCart(dt * creatureDef.speed, self.direction))
		self.direction = self.direction + math.random()*0.1 - 0.05
		
		if self.hasFood then
			ScentHandler.AddScent("food", self.pos, 50, dt)
		else
			ScentHandler.AddScent("explore", self.pos, 50, dt)
		end
	end
	
	function self.Draw(drawQueue, selectedPoint, hoveredPoint, elementType)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
		end})
	end
	
	return self
end

return NewAnt
