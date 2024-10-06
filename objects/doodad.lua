
local function NewDoodad(myDef, pos)
	local self = {}
	self.def = myDef
	self.pos = pos
	
	function self.WriteSaveData()
		return {self.def.name, self.pos}
	end
	
	function self.RemoveAtPos(pos)
		return (util.Dist(pos, self.pos) < 100)
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=self.def.drawLayer + (self.pos[2] + self.pos[1])*0.0001; f=function()
			DoodadHandler.DrawDoodad(self.def, self.pos, 1)
		end})
	end
	
	return self
end

return NewDoodad
