
local DoodadDefs = require("defs/doodadDefs")
local NewDoodad = require("objects/doodad")

local self = {}
local api = {}

function api.DrawDoodad(def, pos, alpha, changeScale, imageOverride)
	if def.image then
		local scale = false
		if def.flip then
			scale = {-1*(def.scale or 1) * (changeScale or 1), (def.scale or 1) * (changeScale or 1)}
		else
			scale = (def.scale or 1) * (changeScale or 1)
		end
		Resources.DrawImage(imageOverride or def.image, pos[1], pos[2], def.rotation, alpha, scale)
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
	local count = IterableMap.Count(self.doodadList)
	IterableMap.ApplySelf(self.doodadList, "RemoveAtPos", pos)
	return count ~= IterableMap.Count(self.doodadList)
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

function api.ShiftEverything(vector)
	IterableMap.ApplySelf(self.doodadList, "ShiftPosition", vector)
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
