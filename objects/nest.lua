

local function NewNest(world, myDef, position)
	local self = {}
	self.pos = position
	self.def = myDef
	self.spawnTimer = 0
	
	function self.Destroy()
		self.destroyed = true
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
	
	function self.Draw(drawQueue, selectedPoint, hoveredPoint, elementType)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
		end})
	end
	
	return self
end

return NewNest