
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local NewBlock = require("objects/block")


function api.Update(dt)
	if not GameHandler.GetLevelBegun() then
		dt = dt*0.05
	end
	IterableMap.ApplySelf(self.blocks, "Update", dt)
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.blocks, "Draw", drawQueue)
end

function api.GetFanDistFactor(pos, left, right, top, bot, direction)
	if direction == 0 then
		return (pos[2] - top) / (bot - top)
	elseif direction == 1 then
		return (pos[1] - left) / (right - left)
	elseif direction == 2 then
		return (bot - pos[2]) / (bot - top)
	elseif direction == 3 then
		return (right - pos[1]) / (right - left)
	end
	return 0
end

function api.AddToBlockCache(blockData)
	for cacheType = 1, #blockData.def.blockTypes do
		local cache = self.blockCache[blockData.def.blockTypes[cacheType]]
		local left, right, top, bot = blockData.GetBlockBounds(Global.BLOCK_CACHE_GRID_SIZE, Global.BLOCK_RADIUS[blockData.def.blockTypes[cacheType]])
		for i = left, right do
			for j = top, bot do
				if not cache[i] then
					cache[i] = {}
				end
				cache[i][j] = (cache[i][j] or 0) + 1
			end
		end
	end
end

function api.RemoveFromBlockCache(blockData)
	for cacheType = 1, #blockData.def.blockTypes do
		local cache = self.blockCache[blockData.def.blockTypes[cacheType]]
		local left, right, top, bot = blockData.GetBlockBounds(Global.BLOCK_CACHE_GRID_SIZE, Global.BLOCK_RADIUS[blockData.def.blockTypes[cacheType]])
		for i = left, right do
			for j = top, bot do
				if not cache[i] then
					cache[i] = {}
				end
				cache[i][j] = (cache[i][j] or 0) - 1
				if cache[i][j] <= 0 then
					cache[i][j] = nil
				end
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

function api.FreeToPlaceAt(cacheType, defName, pos)
	local cache = self.blockCache[cacheType]
	local left, right, top, bot = api.GetBlockBounds(pos, defName, Global.BLOCK_CACHE_GRID_SIZE)
	if left < 0 or right > self.worldWidth or top < 0 or bot > self.worldHeight then
		return false
	end
	for i = left, right do
		for j = top, bot do
			if cache[i] and cache[i][j] then
				return false
			end
		end
	end
	return true
end

function api.SpawnBlock(defName, pos)
	local block = NewBlock(self.world, BlockDefs.defs[defName], pos)
	api.AddToBlockCache(block)
	IterableMap.Add(self.blocks, block)
	return block
end

function api.RemoveBlock(block)
	api.RemoveFromBlockCache(block)
	block.Destroy()
end

function api.BlockAt(cacheType, pos)
	local cache = self.blockCache[cacheType]
	local xSnap = math.floor((pos[1] - Global.BLOCK_CACHE_GRID_SIZE / 2) / Global.BLOCK_CACHE_GRID_SIZE)
	local ySnap = math.floor((pos[2] - Global.BLOCK_CACHE_GRID_SIZE / 2) / Global.BLOCK_CACHE_GRID_SIZE)
	return cache[xSnap] and cache[xSnap][ySnap] and true
end

function api.GetBlockObjectAt(pos)
	return IterableMap.GetFirstSatisfies(self.blocks, "HitTest", pos)
end

function api.GetSaveData()
	local blockData = IterableMap.ApplySelfMapToList(self.blocks, "WriteSaveData")
	return blockData
end

function api.ShiftEverything(vector)
	IterableMap.ApplySelf(self.blocks, "ShiftPosition", vector)
end

function api.MousePressed(x, y, button)
end

function api.Initialize(world)
	local levelData = LevelHandler.GetLevelData()
	self = {
		world = world,
		worldWidth = levelData.width,
		worldHeight = levelData.height,
		blocks = IterableMap.New(),
		blockAt = {},
		blockCache = {
			ant = {},
			flying = {},
			placement = {},
		},
	}
	
	local levelData = LevelHandler.GetLevelData()
	for i = 1, #levelData.blocks do
		local block = levelData.blocks[i]
		api.SpawnBlock(block[1], block[2])
	end
end

return api
