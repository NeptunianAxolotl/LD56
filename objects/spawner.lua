

local function NewSpawner(world, myDef, position, extraData)
	local self = {}
	self.pos = position
	self.def = myDef
	
	if self.def.init then
		self.def.init(self)
	end
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.HitTest(pos)
		return util.Dist(pos, self.pos) < 100
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		self.def.update(self, dt)
	end
	
	function self.WriteSaveData()
		return {self.def.name, self.pos, extraData}
	end
	
	function self.Draw(drawQueue)
		if LevelHandler.GetEditMode() then
			drawQueue:push({y=10000; f=function()
				Font.SetSize(2)
				love.graphics.setColor(0.7, 0.8, 0.2, 0.5)
				love.graphics.circle("line", self.pos[1], self.pos[2], 80)
				love.graphics.printf("spawner: " .. self.def.name, self.pos[1] - 800, self.pos[2], 1600, "center")
			end})
		end
	end
	
	return self
end

return NewSpawner
