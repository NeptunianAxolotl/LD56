
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
	return new
end

function api.SpawnCreature(defName, pos)
	local new = NewCreature(self.world, CreatureDefs.defs[defName], pos)
	IterableMap.Add(self.creatures, new)
	return new
end

function api.AddNest(defName, pos, extraData)
	local nest = NewNest(self.world, NestDefs.defs[defName], pos, extraData)
	IterableMap.Add(self.nests, nest)
	return nest
end

function api.AddFoodSource(defName, pos, extraData)
	local foodSource = NewFoodSource(self.world, FoodDefs.defs[defName], pos, extraData)
	IterableMap.Add(self.foodSources, foodSource)
	return foodSource
end

function api.AddSpawner(defName, pos, extraData)
	local spawner = NewSpawner(self.world, SpawnerDefs.defs[defName], pos, extraData)
	IterableMap.Add(self.spawners, spawner)
	return spawner
end

local function FilterOutNectar(data)
	return data.def.foodType ~= "nectar"
end

local function FilterOutPoison(data)
	return data.def.foodType ~= "poison"
end

local function OnlyGood(data)
	return data.def.foodType == "good"
end

local function FilterOutStuckAnt(data)
	return (data.stuckTime or 0) < 0.5
end

local function ClosestToWithDist(data, maxDistSq, pos, worldWrap, filterFunc)
	if data.destroyed then
		return false
	end
	if filterFunc and not filterFunc(data) then
		return false
	end
	local distSq = (worldWrap and self.worldWrap and
		util.DistSqWithWrap(data.pos[1], data.pos[2], pos[1], pos[2], self.worldWidth, self.worldHeight) or
		util.DistSq(data.pos, pos)
	)
	if maxDistSq and distSq > maxDistSq then
		return false
	end
	if data.def.closestDistScale then
		distSq = distSq / (data.def.closestDistScale * data.def.closestDistScale)
		if maxDistSq and distSq > maxDistSq then
			return false
		end
	end
	return distSq
end

local function GetClosest(thingMap, pos, maxDist, filterFunc)
	local other, minValue = IterableMap.GetMinimum(thingMap, ClosestToWithDist, maxDist and maxDist*maxDist, pos, true, filterFunc)
	if not other then
		return
	end
	return other, math.sqrt(minValue)
end

local function GetClosestNoWrap(thingMap, pos, maxDist, filterFunc)
	local other, minValue = IterableMap.GetMinimum(thingMap, ClosestToWithDist, maxDist and maxDist*maxDist, pos, false, filterFunc)
	if not other then
		return
	end
	return other, math.sqrt(minValue)
end

local function DoFunctionIfInDistance(key, data, index, doFunc, pos, radius, extraData)
	if data.destroyed then
		return false
	end
	local distSq = (self.worldWrap and
		util.DistSqWithWrap(data.pos[1], data.pos[2], pos[1], pos[2], self.worldWidth, self.worldHeight) or
		util.DistSq(data.pos, pos)
	)
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

local function DoFunctionIfInRectangle(key, data, index, doFunc, left, right, top, bot, extraData)
	if data.destroyed then
		return false
	end
	if data.pos[1] < left or data.pos[1] > right or data.pos[2] < top or data.pos[2] > bot then
		return false
	end
	data[doFunc](pos, left, right, top, bot, extraData)
end

function api.DoFunctionToAntsInRectangle(doFunc, left, right, top, bot, extraData)
	IterableMap.Apply(self.ants, DoFunctionIfInRectangle, doFunc, left, right, top, bot, extraData)
end

function api.DoFunctionToCreaturesInRectangle(doFunc, left, right, top, bot, extraData)
	IterableMap.Apply(self.ants, DoFunctionIfInRectangle, doFunc, left, right, top, bot, extraData)
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

function api.ClosestAntNoStuck(pos, dist)
	return GetClosest(self.ants, pos, dist, FilterOutStuckAnt)
end

function api.CountImportantNests()
	return IterableMap.SumWithFunction(self.nests, "CountNests")
end

function api.CountImportantFood()
	return IterableMap.SumWithFunction(self.foodSources, "CountImportantFood")
end

function api.GetNestHealth()
	return IterableMap.SumWithFunction(self.nests, "AddNestHealth")
end

function api.GetFoodHealth()
	return IterableMap.SumWithFunction(self.foodSources, "AddFoodHealth")
end

function api.GetInitialNestHealth()
	return self.initialNestHealth
end

function api.GetInitialFoodHealth()
	return self.initialFoodHealth
end

function api.GetAntCount()
	return IterableMap.Count(self.ants)
end

function api.IsGroundCreatureInRectangle(pos, width, height)
	local creature = IterableMap.GetFirstSatisfies(self.creatures, "GroundRectangleHitTest", pos, width, height)
	return creature and true or false
end

function api.NearNest(pos, dist)
	return GetClosest(self.nests, pos, dist)
end

function api.NearFoodSource(pos, dist)
	return GetClosest(self.foodSources, pos, dist, FilterOutNectar)
end

function api.GetClosestAntGoodFoodFoodNoWrap(pos, dist)
	return GetClosestNoWrap(self.foodSources, pos, dist, OnlyGood)
end

function api.GetClosestNonPoisonFoodNoWrap(pos, dist)
	return GetClosestNoWrap(self.foodSources, pos, dist, FilterOutPoison)
end

function api.DeleteObjectAt(pos)
	local spawner = IterableMap.GetFirstSatisfies(self.spawners, "HitTest", pos)
	if spawner then
		spawner.Destroy()
		return
	end
	local nest = IterableMap.GetFirstSatisfies(self.nests, "HitTest", pos)
	if nest then
		nest.Destroy()
		return
	end
	local foodSource = IterableMap.GetFirstSatisfies(self.foodSources, "HitTest", pos)
	if foodSource then
		foodSource.Destroy()
		return
	end
end

function api.Update(dt)
	if not GameHandler.GetLevelBegun() then
		dt = dt*0.05
	end
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

function api.ShiftEverything(vector)
	IterableMap.ApplySelf(self.nests, "ShiftPosition", vector)
	IterableMap.ApplySelf(self.foodSources, "ShiftPosition", vector)
	IterableMap.ApplySelf(self.spawners, "ShiftPosition", vector)
end

function api.GetSaveData()
	local nestData = IterableMap.ApplySelfMapToList(self.nests, "WriteSaveData")
	local foodData = IterableMap.ApplySelfMapToList(self.foodSources, "WriteSaveData")
	local spawners = IterableMap.ApplySelfMapToList(self.spawners, "WriteSaveData")
	return nestData, foodData, spawners
end

function api.GetAntCount()
  local antCount = 0
  for k,v in pairs(self.ants.dataByKey) do antCount = antCount + 1 end
  return antCount
end

function api.GetFoodAmount()
  local foodCount = 0
  for k,v in pairs(self.foodSources.dataByKey) do 
    if v.foodType ~= "poison" then
      foodCount = foodCount + v.totalFood
      end
    end
  return foodCount
  end

function api.PreInitialize(world)
	local levelData = LevelHandler.GetLevelData()
	self = {
		world = world,
		ants = IterableMap.New(),
		creatures = IterableMap.New(),
		spawners = IterableMap.New(),
		currentTime = 0,
		nests = IterableMap.New(),
		foodSources = IterableMap.New(),
		worldWidth = levelData.width,
		worldHeight = levelData.height,
		worldWrap = levelData.worldWrap,
	}
end

function api.Initialize(world)
	local levelData = LevelHandler.GetLevelData()

	for i = 1, #levelData.nests do
		local nest = levelData.nests[i]
		api.AddNest(nest[1], nest[2], nest[3])
	end
	for i = 1, #levelData.food do
		local food = levelData.food[i]
		api.AddFoodSource(food[1], food[2], food[3])
	end
	for i = 1, #levelData.spawners do
		local spawner = levelData.spawners[i]
		api.AddSpawner(spawner[1], spawner[2], spawner[3])
	end
	
	self.initialNestHealth = api.GetNestHealth()
	self.initialFoodHealth = api.GetFoodHealth()
end


return api
