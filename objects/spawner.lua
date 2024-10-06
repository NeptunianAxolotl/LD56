

local function NewSpawner(world, myDef, position)
	local self = {}
	self.pos = position
	self.def = myDef
	
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
		self.def.update(dt)
	end
	
	function self.WriteSaveData()
		return {self.def.name, self.pos}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=18; f=function()
			Font.SetSize(2)
			love.graphics.setColor(0.7, 0.8, 0.2, 0.5)
			love.graphics.circle("line", self.pos[1], self.pos[2], 200)
			love.graphics.printf("spawner: " .. self.def.name, self.pos[1] - 200, self.pos[2], 400, "center")
		end})
	end
	
	return self
end

return NewSpawner
