
local function NewDoodad(myDef, pos)
	local self = {}
	self.def = myDef
	self.pos = pos
	
	function self.WriteSaveData()
		return {self.def.name, self.pos}
	end
	
	function self.RemoveAtPos(pos)
		return (util.Dist(pos, self.pos) < 70)
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=self.def.drawLayer + (self.pos[2] + self.pos[1])*0.0001; f=function()
			DoodadHandler.DrawDoodad(self.def, self.pos, 1)
		end})
		if LevelHandler.GetEditMode() then
			drawQueue:push({y=1000 + (self.pos[2] + self.pos[1])*0.0001; f=function()
				love.graphics.setColor(0, 1, 0, 1)
				love.graphics.setLineWidth(2)
				love.graphics.circle("line", self.pos[1], self.pos[2], 70)
				love.graphics.setLineWidth(1)
			end})
		end
	end
	
	return self
end

return NewDoodad
