

local function NewBlock(world, blockDef, position)
	local self = {}
	self.pos = position
	self.def = blockDef
	
	if self.def.pushWidth then
		self.extraFanData = {
			pos = self.pos,
			direction = self.def.fanCardinalDirection,
			strength = self.def.fanStrength,
			pushVector = util.Unit({self.def.pushOffsetX, self.def.pushOffsetY}),
		}
	end
	
	if self.def.foodType then
		self.foodSource = AntHandler.AddFoodSource(self.def.foodType, util.CopyTable(self.pos))
	end
	
	function self.Destroy()
		self.destroyed = true
		if self.foodSource then
			self.foodSource.Destroy()
		end
	end
	
	function self.ShiftPosition(vector)
		self.pos = util.Add(self.pos, vector)
	end
	
	function self.Update(dt)
		if self.destroyed then
			return true
		end
		
		if self.def.pushWidth then
			self.extraFanData.dt = dt
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
		if self.def.update then
			self.def.update(self, dt)
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
				if self.fanAnim and self.fanAnim > 0.5 then
					DoodadHandler.DrawDoodad(self.def, self.pos, 1, 1, self.def.image2)
				else
					DoodadHandler.DrawDoodad(self.def, self.pos, 1)
				end
			else
				self.def.draw(self, drawQueue)
			end
		end})
		if LevelHandler.GetEditMode() or LevelHandler.GetDebugDraw() then
			drawQueue:push({y=1000 + (self.pos[2] + self.pos[1])*0.0001; f=function()
				if self.def.editColor then
					love.graphics.setColor(self.def.editColor[1], self.def.editColor[2], self.def.editColor[3], 1)
				else
					love.graphics.setColor(1, 1, 1, 1)
				end
				love.graphics.setLineWidth(4)
				love.graphics.rectangle("line", self.pos[1] - self.def.width/2, self.pos[2] - self.def.height/2, self.def.width, self.def.height)
				love.graphics.setLineWidth(1)
				
				if self.def.editFillColor then
					love.graphics.setColor(self.def.editFillColor[1], self.def.editFillColor[2], self.def.editFillColor[3], 0.4)
				else
					love.graphics.setColor(1, 0, 1, 0.2)
				end
				love.graphics.rectangle("fill", self.pos[1] - self.def.width/2, self.pos[2] - self.def.height/2, self.def.width, self.def.height)
				
				if self.def.pushWidth then
					love.graphics.setColor(0, 0, 1, 1)
					love.graphics.setLineWidth(6)
					love.graphics.rectangle("line",
						self.pos[1] + self.def.pushOffsetX - self.def.pushWidth/2,
						self.pos[2] + self.def.pushOffsetY - self.def.pushHeight/2,
						self.def.pushWidth, self.def.pushHeight
					)
					love.graphics.setLineWidth(1)
				end
			end})
		end
	end
	
	return self
end

return NewBlock