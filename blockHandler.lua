
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local NewBlock = require("objects/block")


function api.Update(dt)
	IterableMap.ApplySelf(self.blocks, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.blocks, "Draw", drawQueue)
end

local function AddToBlockCache(blockData)
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


local function RemoveFromBlockCache(blockData)
	local left, right, top, bot = blockData.GetBlockBounds(Global.BLOCK_CACHE_GRID_SIZE, Global.ANT_BLOCK_RADIUS)
	for i = left, right do
		for j = top, bot do
			if not self.blockCache[i] then
				self.blockCache[i] = {}
			end
			self.blockCache[i][j] = (self.blockCache[i][j] or 0) - 1
			if self.blockCache[i][j] <= 0 then
				self.blockCache[i][j] = nil
			end
		end
	end
end

function api.GetBlockBounds(pos, defName, snap, radius)
	local def = BlockDefs.defs[defName]
	radius = radius or 0
	local left = pos[1] - def.width/2 - radius
	local right = pos[1] + def.width/2 + radius
	local top = pos[2] - def.height/2 - radius
	local bot = pos[2] + def.height/2 + radius
	if snap then
		left = math.floor(left / snap)
		right = math.ceil(right / snap)
		top = math.floor(top / snap)
		bot = math.ceil(bot / snap)
	end
	return left, right, top, bot
end

function api.FreeToPlaceAt(defName, pos)
	local left, right, top, bot = api.GetBlockBounds(pos, defName, Global.BLOCK_CACHE_GRID_SIZE)
	for i = left, right do
		for j = top, bot do
			if self.blockCache[i] and self.blockCache[i][j] then
				return false
			end
		end
	end
	return true
end

function api.SpawnBlock(defName, pos)
	local block = NewBlock(self.world, BlockDefs.defs[defName], pos)
	AddToBlockCache(block)
	IterableMap.Add(self.blocks, block)
	return block
end

function api.RemoveBlock(block)
	RemoveFromBlockCache(block)
	block.Destroy()
end

function api.BlockAt(pos)
	local xSnap = math.floor((pos[1] - Global.BLOCK_CACHE_GRID_SIZE / 2) / Global.BLOCK_CACHE_GRID_SIZE)
	local ySnap = math.floor((pos[2] - Global.BLOCK_CACHE_GRID_SIZE / 2) / Global.BLOCK_CACHE_GRID_SIZE)
	return self.blockCache[xSnap] and self.blockCache[xSnap][ySnap] and true
end


function api.GetBlockObjectAt(pos)
	return IterableMap.GetFirstSatisfies(self.blocks, "HitTest", pos)
end

function api.MousePressed(x, y, button)
end

function api.Initialize(world)
	self = {
		world = world,
		blocks = IterableMap.New(),
		blockAt = {},
		blockCache = {},
	}
	
	local levelData = LevelHandler.GetLevelData()
	for i = 1, #levelData.blocks do
		local block = levelData.blocks[i]
		api.SpawnBlock(block[1], block[2])
	end
end

return api
