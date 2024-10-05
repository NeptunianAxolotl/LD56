

local function NewNest(world, myDef, position)
	local self = {}
	self.pos = position
	self.def = myDef
	self.health = self.def.health
	self.spawnTimer = 0
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.ApplyFood(foodType, foodValue)
		if foodType == "poison" then
			self.health = self.health - foodValue
		end
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
	
	function self.WriteSaveData()
		return {self.def.name, self.pos}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=18; f=function()
			self.def.draw(self, drawQueue)
			Font.SetSize(2)
			love.graphics.setColor(0.7, 0.8, 0.2, 0.5)
			love.graphics.print("health " .. self.health, self.pos[1] - 80, self.pos[2])
		end})
	end
	
	return self
end

return NewNest