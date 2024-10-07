local self = {}
local api = {}

local function InitializeScent(name, linger, red, green, blue)
	local levelData = LevelHandler.GetLevelData()
	local width = math.floor(levelData.width / Global.SCENT_GRID_SIZE)
	local height = math.floor(levelData.height / Global.SCENT_GRID_SIZE)
	local imageData = love.image.newImageData(width, height)

	imageData:mapPixel(function(x,y, r,g,b,a)
		return red, green, blue, a
	end)

	local strength = {}

	for idx = 1, width * height do
		strength[idx] = 0
	end

	local scent = {
		strength = strength,
		gridSize = Global.SCENT_GRID_SIZE,
		linger = linger,
		imageData = imageData,
		image = love.graphics.newImage(imageData),
		width = width,
		height = height
	}
	self.scents[name] = scent
end

function api.GetScent(name, pos, canBeBlocked)
	if canBeBlocked and BlockHandler.BlockAt("ant", pos) then
		return 0
	end
	local scent = self.scents[name]
	local x, y = TerrainHandler.WrapGrid(math.floor(pos[1]/scent.gridSize), math.floor(pos[2]/scent.gridSize))
	return scent.strength[1+y*scent.width+x]
end

function api.AddScent(name, pos, radius, newStrength)
	local scent = self.scents[name]
	local gridSize = scent.gridSize
	local xFrac = (pos[1] - 0.5)/gridSize
	local yFrac = (pos[2] - 0.5)/gridSize
	local x = math.floor(pos[1]/gridSize)
	local y = math.floor(pos[2]/gridSize)
	local gridRad = radius/gridSize
	local gridRadSq = gridRad*gridRad

	local scent_strength = scent.strength
	local width = scent.width

	for j = math.floor(y - gridRad), math.ceil(y + gridRad) do
		for i = math.floor(x - gridRad), math.ceil(x + gridRad) do
			local iw, jw = TerrainHandler.WrapGrid(i, j)
			local distSq = (xFrac - i)*(xFrac - i) + (yFrac - j)*(yFrac - j)
			if distSq < gridRadSq then
				local idx = 1+jw*width+iw
				local outStrength = scent_strength[idx] + newStrength * (1 - distSq / gridRadSq)
				if outStrength < 0 then
					outStrength = 0
				end
				scent_strength[idx] = outStrength
			end
		end
	end
end

function api.Update(dt)
	if not GameHandler.GetLevelBegun() then
		dt = dt*0.05
	end

	for name, scent in pairs(self.scents) do
		local decayBy = math.pow(scent.linger, dt)
		local scent_strength = scent.strength
		for idx = 1, #scent_strength do
			scent_strength[idx] = scent_strength[idx] * decayBy
		end
	end
end

local function DrawScent(name, alpha, strengthScale)
	local scent = self.scents[name]
	local width = scent.width

	local imageData = scent.imageData
	local scent_strength = scent.strength

	imageData:mapPixel(function(x,y, r,g,b,a)
		local strength = scent_strength[1+y*width+x]
		return r, g, b, (alpha * strength / (strengthScale + strength))
	end)

	local image = scent.image
	image:replacePixels(imageData)
	love.graphics.setColor(1, 1, 1, 1)
	love.graphics.draw(image, 0, 0, 0, scent.gridSize)
end

function api.Draw(drawQueue)
	drawQueue:push({y=30; f=function()
		DrawScent("explore", 0.8, 6)
		DrawScent("food", 0.6, 10)
	end})
end

function api.Initialize(world)
	self = {
		world = world,
		currentTime = 0,
		scents = {},
	}
	InitializeScent("explore", Global.EXPLORE_DECAY, 1, 0, 0)
	InitializeScent("food", Global.FOOD_DECAY, 0, 0.5, 1)
end

return api
