
local self = {}
local api = {}

local function InitializeScent(name, linger)
	local scent = {
		strength = {},
		lastTouch = {},
		gridSize = Global.SCENT_GRID_SIZE,
		linger = linger,
	}
	self.scents[name] = scent
end

function api.GetScentRawPos(name, x, y)
	x, y = TerrainHandler.WrapGrid(x, y)
	local scent = self.scents[name]
	if not scent.strength[x] then
		return 0
	end
	local strength = scent.strength[x][y] or 0
	if strength == 0 then
		return 0
	end
	local touch = scent.lastTouch[x][y]
	return strength * math.pow(scent.linger, self.currentTime - touch)
end

function api.GetScent(name, pos, canBeBlocked)
	if canBeBlocked and BlockHandler.BlockAt("ant", pos) then
		return 0
	end
	local scent = self.scents[name]
	local x = math.floor(pos[1]/scent.gridSize)
	local y = math.floor(pos[2]/scent.gridSize)
	return api.GetScentRawPos(name, x, y)
end

function api.AddScent(name, pos, radius, newStrength)
	local scent = self.scents[name]
	local xFrac = (pos[1] - 0.5)/scent.gridSize
	local yFrac = (pos[2] - 0.5)/scent.gridSize
	local x = math.floor(pos[1]/scent.gridSize)
	local y = math.floor(pos[2]/scent.gridSize)
	local gridRad = radius/scent.gridSize
	local gridRadSq = gridRad*gridRad
	for i = math.floor(x - gridRad), math.ceil(x + gridRad) do
		for j = math.floor(y - gridRad), math.ceil(y + gridRad) do
			local iw, jw = TerrainHandler.WrapGrid(i, j)
			local distSq = (xFrac - i)*(xFrac - i) + (yFrac - j)*(yFrac - j)
			if distSq < gridRadSq then
				local existing = api.GetScentRawPos(name, i, j)
				if not scent.strength[iw] then
					scent.strength[iw] = {}
					scent.lastTouch[iw] = {}
				end
				scent.strength[iw][jw] = existing + newStrength * (1 - distSq / gridRadSq)
				scent.lastTouch[iw][jw] = self.currentTime
			end
		end
	end
	
	
end

function api.Update(dt)
	self.currentTime = self.currentTime + dt
end

local function DrawScent(name, red, green, blue)
	local scale = self.scents[name].gridSize
	local levelData = LevelHandler.GetLevelData()
	local width = math.floor(levelData.width / Global.SCENT_GRID_SIZE) - 1
	local height = math.floor(levelData.height / Global.SCENT_GRID_SIZE) - 1
	for x = 0, width do
		for y = 0, height do
			local strength = api.GetScentRawPos(name, x, y)
			if strength > 0 then
				love.graphics.setColor(red, green, blue, strength / (10 + strength))
				love.graphics.rectangle("fill", x*scale, y*scale, scale, scale, 0, 0, 0)
			end
		end
	end
end

function api.Draw(drawQueue)
	drawQueue:push({y=0; f=function()
		DrawScent("explore", 1, 0, 0)
		DrawScent("food", 0, 1, 1)
	end})
end

function api.Initialize(world)
	self = {
		world = world,
		currentTime = 0,
		scents = {},
	}
	InitializeScent("explore", 0.94)
	InitializeScent("food", 0.92)
end

return api
