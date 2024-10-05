
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local NewBlock = require("objects/block")

function api.SpawnBlock(defName, pos)
	local new = NewBlock(self.world, BlockDefs.defs[defName], pos)
	IterableMap.Add(self.blocks, new)
end

function api.Update(dt)
	IterableMap.ApplySelf(self.blocks, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.blocks, "Draw", drawQueue)
end

function api.Initialize(world)
	self = {
		world = world,
		blocks = IterableMap.New(),
	}
	
	local levelData = LevelHandler.GetLevelData()
	for i = 1, #levelData.blocks do
		local block = levelData.blocks[i]
		api.SpawnBlock(block[1], block[2])
	end
end

return api
