
local self = {}
local api = {}

local CreatureDefs = require("defs/creatureDefs")
local NewAnt = require("objects/ant")

local function SpawnAnt()
	local pos = {400, 400}
	local new = NewAnt(self.world, CreatureDefs.defs['ant'], pos)
	
	IterableMap.Add(self.ants, new)
	print(IterableMap.Count(self.ants))
end

local function SpawnAntsUpdate(dt)
	self.spawnTimer = self.spawnTimer + dt
	while self.spawnTimer > 1 / self.spawnFrequency do
		SpawnAnt()
		self.spawnTimer = self.spawnTimer - 1 / self.spawnFrequency
	end
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
	local other = IterableMap.GetMinimum(thingMap, ClosestToWithDist, maxDist*maxDist, pos, filterFunc)
	if not other then
		return
	end
	return other
end

function api.NearNest(pos, dist)
	return GetClosest(self.nests, pos, dist)
end

function api.NearFoodSource(pos, dist)
	return GetClosest(self.foodSources, pos, dist)
end

function api.AddNest(pos)
	local nest = {
		pos = pos,
	}
	IterableMap.Add(self.nests, nest)
end

function api.AddFoodSource(pos)
	local foodSource = {
		pos = pos,
	}
	IterableMap.Add(self.foodSources, foodSource)
end

function api.Update(dt)
	SpawnAntsUpdate(dt)
	IterableMap.ApplySelf(self.ants, "Update", dt)
	self.currentTime = self.currentTime + dt
end

function api.Draw(drawQueue)
	IterableMap.ApplySelf(self.ants, "Draw", drawQueue)
end

function api.Initialize(world)
	self = {
		world = world,
		ants = IterableMap.New(),
		spawnFrequency = 6,
		spawnTimer = 0,
		currentTime = 0,
		nests = IterableMap.New(),
		foodSources = IterableMap.New(),
	}
	
	api.AddNest({400, 400})
	api.AddFoodSource({1300, 700})
end

return api
