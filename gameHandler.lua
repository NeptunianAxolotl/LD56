
local Font = require("include/font")

MusicHandler = require("musicHandler")
BGMHandler = require("bgmHandler") -- Uncomment when I have the remotest confidence this works - LWG

local self = {}
local api = {}

--------------------------------------------------
-- Updating
--------------------------------------------------

--------------------------------------------------
-- API
--------------------------------------------------

function api.ToggleMenu()
	self.menuOpen = not self.menuOpen
	self.world.SetMenuState(self.menuOpen)
end

function api.MousePressed(x, y)
end

function api.GetViewRestriction()
	local pointsToView = {{0, 0}, {800, 800}}
	return pointsToView
end

function api.BlockHealthChanges()
	return self.world.GetGameOver() or self.sandboxMode
end

function api.GetSandboxMode()
	return self.sandboxMode
end

function api.ToggleSandboxMode()
	self.sandboxMode = not self.sandboxMode
end

function api.BeginLevel()
	self.levelBegun = true
end

function api.GetLevelBegun()
	return self.levelBegun
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
	local levelData = LevelHandler.GetLevelData()
	local nestCount = AntHandler.CountImportantNests()
	local foodCount = AntHandler.CountImportantFood()
	if nestCount <= 0 then
		if not self.world.GetGameOver() and not LevelHandler.GetEditMode() then
			ItemHandler.ReplaceActiveItem()
		end
		self.world.SetGameOver(true)
	end
	if foodCount < levelData.mustRetainAtLeastThisMuchFood and not LevelHandler.GetEditMode() then
		if not self.world.GetGameOver() then
			ItemHandler.ReplaceActiveItem()
		end
		self.world.SetGameOver(false)
	end
end

function api.DrawInterface()
	local windowX, windowY = love.window.getMode()
end

function api.Initialize(parentWorld)
	self = {
		world = parentWorld,
	}
end

return api
