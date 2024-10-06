

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
	
	function self.GetBlockBounds(snap, radius)
		return BlockHandler.GetBlockBounds(self.pos, self.def.name, snap, radius)
	end
	
	function self.HitTest(pos)
		if self.pos[1] - self.def.width/2 > pos[1] then
			return false
		end
		if self.pos[2] - self.def.height/2 > pos[2] then
			return false
		end
		if self.pos[1] + self.def.width/2 < pos[1] then
			return false
		end
		if self.pos[2] + self.def.height/2 < pos[2] then
			return false
		end
		return true
	end
	
	function self.WriteSaveData()
		return {self.def.name, self.pos}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=self.def.drawLayer + self.pos[1]*0.0001 + self.pos[2]*0.0001; f=function()
			if self.def.image then
				DoodadHandler.DrawDoodad(self.def, self.pos, 1)
			else
				self.def.draw(self, drawQueue)
			end
			if LevelHandler.GetEditMode() then
				love.graphics.setColor(1, 1, 1, 1)
				love.graphics.setLineWidth(4)
				love.graphics.rectangle("line", self.pos[1] - self.def.width/2, self.pos[2] - self.def.height/2, self.def.width, self.def.height)
				love.graphics.setLineWidth(1)
			end
		end})
	end
	
	return self
end

return NewBlock