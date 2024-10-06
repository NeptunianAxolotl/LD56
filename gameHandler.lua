
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
	world.SetMenuState(self.menuOpen)
end

function api.MousePressed(x, y)
	local windowX, windowY = love.window.getMode()
	local drawPos = world.ScreenToInterface({windowX, 0})
end

function api.GetViewRestriction()
	local pointsToView = {{0, 0}, {800, 800}}
	return pointsToView
end

--------------------------------------------------
-- Updating
--------------------------------------------------

function api.Update(dt)
	local nestCount = AntHandler.CountImportantNests()
	local foodCount = AntHandler.CountImportantFood()
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
