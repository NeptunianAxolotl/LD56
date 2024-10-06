

local function NewBlock(world, blockDef, position)
	local self = {}
	self.pos = position
	self.def = blockDef
	
	if self.def.pushWidth then
		self.extraFanData = {
			dt = dt,
			direction = self.def.fanCardinalDirection,
			strength = self.def.fanStrength,
			pushVector = util.Unit({self.def.pushOffsetX, self.def.pushOffsetY}),
		}
	end
	
	function self.Destroy()
		self.destroyed = true
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		
		if self.def.pushWidth then
			local fanX, fanY = self.pos[1] + self.def.pushOffsetX, self.pos[2] + self.def.pushOffsetY
			AntHandler.DoFunctionToAntsInRectangle("ApplyFanPush", 
				fanX - self.def.pushWidth/2, fanX + self.def.pushWidth/2,
				fanY - self.def.pushHeight/2, fanY + self.def.pushHeight/2,
				self.extraFanData
			)
			AntHandler.DoFunctionToCreaturesInRectangle("ApplyFanPush",
				fanX - self.def.pushWidth/2, fanX + self.def.pushWidth/2,
				fanY - self.def.pushHeight/2, fanY + self.def.pushHeight/2,
				self.extraFanData
			)
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
		if self.def.ignoreSave then
			return false
		end
		return {self.def.name, self.pos}
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=self.def.drawLayer + self.pos[1]*0.001 + self.pos[2]*0.0001; f=function()
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
				
				if self.def.pushWidth then
					love.graphics.setColor(0, 0, 1, 1)
					love.graphics.setLineWidth(6)
					love.graphics.rectangle("line", self.pos[1] + self.def.pushOffsetX - self.def.pushWidth/2, self.pos[2] + self.def.pushOffsetY - self.def.pushHeight/2, self.def.pushWidth, self.def.pushHeight)
					love.graphics.setLineWidth(1)
				end
			end
		end})
	end
	
	return self
end

return NewBlock