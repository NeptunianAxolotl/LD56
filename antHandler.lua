
local self = {}
local api = {}

local CreatureDefs = require("defs/creatureDefs")
local SpawnerDefs = require("defs/spawnerDefs")
local NestDefs = require("defs/nestDefs")
local FoodDefs = require("defs/foodDefs")

local NewAnt = require("objects/ant")
local NewCreature = require("objects/creature")
local NewSpawner = require("objects/spawner")
local NewNest = require("objects/nest")
local NewFoodSource = require("objects/foodSource")

function api.SpawnAnt(defName, pos)
	local new = NewAnt(self.world, CreatureDefs.defs[defName], pos)
	IterableMap.Add(self.ants, new)
end

function api.SpawnCreature(defName, pos)
	local new = NewCreature(self.world, CreatureDefs.defs[defName], pos)
	IterableMap.Add(self.creatures, new)
end

function api.AddNest(defName, pos)
	local nest = NewNest(self.world, NestDefs.defs[defName], pos)
	IterableMap.Add(self.nests, nest)
end

function api.AddFoodSource(defName, pos)
	local foodSource = NewFoodSource(self.world, FoodDefs.defs[defName], pos)
	IterableMap.Add(self.foodSources, foodSource)
end

function api.AddSpawner(defName, pos)
	local spawner = NewSpawner(self.world, SpawnerDefs.defs[defName], pos)
	IterableMap.Add(self.spawners, spawner)
end

local function ClosestToWithDist(data, maxDistSq, pos, filterFunc)
	if data.destroyed then
		return false
	end
	if filterFunc and not filterFunc(data) then
		return false
	end
	local distSq = util.DistSqVectors(data.pos, pos)
	if distSq > maxDistSq then
		return false
	end
	return distSq
end

local function GetClosest(thingMap, pos, maxDist, filterFunc)
	local other, minValue = IterableMap.GetMinimum(thingMap, ClosestToWithDist, maxDist*maxDist, pos, filterFunc)
	if not other then
		return
	end
	return other, math.sqrt(minValue)
end

local function DoFunctionIfInDistance(key, data, index, doFunc, pos, radius, extraData)
	if data.destroyed then
		return false
	end
	local distSq = util.DistSqVectors(data.pos, pos)
	if distSq > radius*radius then
		return false
	end
	data[doFunc](pos, math.sqrt(distSq), radius, extraData)
end

function api.DoFunctionToAntsInArea(doFunc, pos, radius, extraData)
	IterableMap.Apply(self.ants, DoFunctionIfInDistance, doFunc, pos, radius, extraData)
end

function api.DoFunctionToCreaturesInArea(doFunc, pos, radius, extraData)
	IterableMap.Apply(self.creatures, DoFunctionIfInDistance, doFunc, pos, radius, extraData)
end

function api.PickupAnt(pos, radius)
	local ant = GetClosest(self.ants, pos, radius)
	if not ant then
		return false
	end
	ant.SetPickedUp()
	return ant
end

function api.DropAnt(pos, ant)
	if BlockHandler.BlockAt("ant", pos) then
		return false
	end
	ant.DropAt(pos)
	return true
end

function api.ClosestAnt(pos, dist)
	return GetClosest(self.ants, pos, dist)
end

function api.NearNest(pos, dist)
	return GetClosest(self.nests, pos, dist)
end

function api.NearFoodSource(pos, dist)
	return GetClosest(self.foodSources, pos, dist)
end

function api.Update(dt)
	IterableMap.ApplySelf(self.ants, "Update", dt)
	IterableMap.ApplySelf(self.creatures, "Update", dt)
	IterableMap.ApplySelf(self.nests, "Update", dt)
	IterableMap.ApplySelf(self.foodSources, "Update", dt)
	IterableMap.ApplySelf(self.spawners, "Update", dt)
	self.currentTime = self.currentTime + dt
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.ants, "Draw", drawQueue)
	IterableMap.ApplySelf(self.creatures, "Draw", drawQueue)
	IterableMap.ApplySelf(self.nests, "Draw", drawQueue)
	IterableMap.ApplySelf(self.foodSources, "Draw", drawQueue)
	IterableMap.ApplySelf(self.spawners, "Draw", drawQueue)
end

function api.GetSaveData()
	local nestData = IterableMap.ApplySelfMapToList(self.nests, "WriteSaveData")
	local foodData = IterableMap.ApplySelfMapToList(self.foodSources, "WriteSaveData")
	local spawners = IterableMap.ApplySelfMapToList(self.spawners, "WriteSaveData")
	return nestData, foodData, spawners
end

function api.Initialize(world)
	self = {
		world = world,
		ants = IterableMap.New(),
		creatures = IterableMap.New(),
		spawners = IterableMap.New(),
		currentTime = 0,
		nests = IterableMap.New(),
		foodSources = IterableMap.New(),
	}
	
	local levelData = LevelHandler.GetLevelData()
	for i = 1, #levelData.nests do
		local nest = levelData.nests[i]
		api.AddNest(nest[1], nest[2])
	end
	for i = 1, #levelData.food do
		local food = levelData.food[i]
		api.AddFoodSource(food[1], food[2])
	end
	for i = 1, #levelData.spawners do
		local spawner = levelData.spawners[i]
		api.AddSpawner(spawner[1], spawner[2])
	end
end

return api
