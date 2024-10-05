local Font = require("include/font")

local self = {}
local api = {}

local function SetupLevel()
	-- TODO self.map = {}
	
endfunction api.WrapPosInPlace(pos)	if pos[1] < 0 then		pos[1] = pos[1] + self.width	end	if pos[2] < 0 then		pos[2] = pos[2] + self.height	end	if pos[1] >= self.width then		pos[1] = pos[1] - self.width	end	if pos[2] >= self.height then		pos[2] = pos[2] - self.height	endend
function api.WrapGrid(x, y)	if x < 0 then		x = x + self.gridWidth	end	if y < 0 then		y = y + self.gridHeight	end	if x >= self.gridWidth then		x = x - self.gridWidth	end	if y >= self.gridHeight then		y = y - self.gridHeight	end	return x, yend
function api.Draw(drawQueue)
	drawQueue:push({y=0; f=function()		love.graphics.rectangle("line", 0, 0, self.width, self.height)
	end})
end

function api.Initialize(world, levelIndex, mapDataOverride)	local levelData = LevelHandler.GetLevelData()
	self = {
		world = world,		width = levelData.width,		height = levelData.height,		gridWidth = math.floor(levelData.width / Global.SCENT_GRID_SIZE),		gridHeight = math.floor(levelData.height / Global.SCENT_GRID_SIZE),
	}
	SetupLevel(levelIndex, mapDataOverride)
end

return api
