
local Font = require("include/font")

local self = {}
local api = {}

local function SetupLevel()
	-- TODO self.map = {}
	local levelData = LevelHandler.GetLevelData()

	local plankimages = {"wood1", "wood2", "wood3", "wood4"}

	local plankarray = {}
	for i = 1, 100 do 
		plankarray[i] = {}
		for j=1,10 do 
			plankarray[i][j] = util.SampleList(plankimages)
		end
	end
	self.plankarray =  plankarray
end

function api.WrapPosInPlace(pos)
	if pos[1] < 0 then
		pos[1] = pos[1] + self.width
	end
	if pos[2] < 0 then
		pos[2] = pos[2] + self.height
	end
	if pos[1] >= self.width then
		pos[1] = pos[1] - self.width
	end
	if pos[2] >= self.height then
		pos[2] = pos[2] - self.height
	end
end

function api.WrapGrid(x, y)
	if x < 0 then
		x = x + self.gridWidth
	end
	if y < 0 then
		y = y + self.gridHeight
	end
	if x >= self.gridWidth then
		x = x - self.gridWidth
	end
	if y >= self.gridHeight then
		y = y - self.gridHeight
	end
	return x, y
end

function api.Draw(drawQueue)
	drawQueue:push({y=0; f=function()
		love.graphics.setColor(0, 0, 0, 1)
		love.graphics.rectangle("line", 0, 0, self.width, self.height)

		for i = 1, #self.plankarray do
			for j = 1, #self.plankarray[i] do
				local x = i * 50 + -50
				local y = j * 200 + -250
				--DrawImage(image, x, y, rotation, alpha, scale)
				Resources.DrawImage(self.plankarray[i][j], x, y, math.pi/2, 1, 0.2)
			end
		end

	end})
end

function api.Initialize(world, levelIndex, mapDataOverride)
	local levelData = LevelHandler.GetLevelData()
	self = {
		world = world,
		width = levelData.width,
		height = levelData.height,
		gridWidth = math.floor(levelData.width / Global.SCENT_GRID_SIZE),
		gridHeight = math.floor(levelData.height / Global.SCENT_GRID_SIZE),
	}
	SetupLevel(levelIndex, mapDataOverride)
end

return api
