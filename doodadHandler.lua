
local DoodadDefs = require("defs/doodadDefs")
local NewDoodad = require("objects/doodad")

local self = {}
local api = {}

function api.DrawDoodad(def, pos, alpha)
	if def.image then
		Resources.DrawImage(def.image, pos[1], pos[2], def.rotation, false, def.scale*(def.flip and -1 or 1))
	else
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("fill", pos[1] - def.width/2, pos[2] - def.height/2, def.width, def.height)
	end
end

function api.AddDoodad(doodadType, pos)
	local doodadDef = DoodadDefs.defs[doodadType]
	local newDoodad = NewDoodad(doodadDef, pos)
	IterableMap.Add(self.doodadList, newDoodad)
	return newDoodad
end

function api.RemoveDoodads(pos)
	IterableMap.ApplySelf(self.doodadList, "RemoveAtPos", pos)
end

local function SetupWorld()
	local levelData = LevelHandler.GetLevelData()
	if levelData.doodads then
		for i = 1, #levelData.doodads do
			local doodad = levelData.doodads[i]
			api.AddDoodad(doodad[1], doodad[2])
		end
	end
end

function api.ExportObjects()
	local objList = IterableMap.ApplySelfMapToList(self.doodadList, "WriteSaveData")
	return objList
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.doodadList, "Draw", drawQueue)
end

function api.Initialize(world)
	self = {
		doodadList = IterableMap.New(),
		world = world,
	}
	SetupWorld()
end

return api
