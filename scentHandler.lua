
local self = {}
local api = {}

local function InitializeScent(name, linger)
	local scent = {
		strength = {},
		lastTouch = {},
		gridSize = 10,
		linger = linger,
	}
	self.scents[name] = scent
end

function api.GetScentRawPos(name, x, y)
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

function api.GetScent(name, pos)
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
			local distSq = (xFrac - i)*(xFrac - i) + (yFrac - j)*(yFrac - j)
			if distSq < gridRadSq then
				local existing = api.GetScentRawPos(name, i, j)
				if not scent.strength[i] then
					scent.strength[i] = {}
					scent.lastTouch[i] = {}
				end
				scent.strength[i][j] = existing + newStrength * (1 - distSq / gridRadSq)
				scent.lastTouch[i][j] = self.currentTime
			end
		end
	end
	
	
end

function api.Update(dt)
	self.currentTime = self.currentTime + dt
end

local function DrawScent(name, red, green, blue)
	local scale = self.scents[name].gridSize
	for x = 1, 200 do
		for y = 1, 200 do
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
	InitializeScent("explore", 0.95)
	InitializeScent("food", 0.88)
end

return api
