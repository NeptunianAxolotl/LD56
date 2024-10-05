
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
	}
end

return api
