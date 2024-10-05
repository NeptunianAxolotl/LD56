
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

function api.BlockAt(pos)
	local xSnap = math.floor((pos[1] - Global.BLOCK_CACHE_GRID_SIZE / 2) / Global.BLOCK_CACHE_GRID_SIZE)
	local ySnap = math.floor((pos[2] - Global.BLOCK_CACHE_GRID_SIZE / 2) / Global.BLOCK_CACHE_GRID_SIZE)
	return self.blockCache[xSnap] and self.blockCache[xSnap][ySnap]
end

local function AddToBlockCache(_, blockData)
	local left, right, top, bot = blockData.GetBlockBounds(Global.BLOCK_CACHE_GRID_SIZE, Global.ANT_BLOCK_RADIUS)
	for i = left, right do
		for j = top, bot do
			if not self.blockCache[i] then
				self.blockCache[i] = {}
			end
			self.blockCache[i][j] = (self.blockCache[i][j] or 0) + 1
		end
	end
end

local function BuildBlockCache()
	self.blockCache = {}
	IterableMap.Apply(self.blocks, AddToBlockCache)
end

function api.Initialize(world)
	self = {
		world = world,
		blocks = IterableMap.New(),
		blockAt = {}
	}
	
	local levelData = LevelHandler.GetLevelData()
	for i = 1, #levelData.blocks do
		local block = levelData.blocks[i]
		api.SpawnBlock(block[1], block[2])
	end
	
	BuildBlockCache()
end

return api
