
EffectsHandler = require("effectsHandler")
DialogueHandler = require("dialogueHandler")
TerrainHandler = require("terrainHandler")
ShadowHandler = require("shadowHandler")

ItemHandler = require("itemHandler")
BlockHandler = require("blockHandler")
AntHandler = require("antHandler")
ScentHandler = require("scentHandler")
LevelHandler = require("levelHandler")
PlayerHandler = require("playerHandler")
DoodadHandler = require("doodadHandler")

InterfaceUtil = require("utilities/interfaceUtilities")
Delay = require("utilities/delay")

local PhysicsHandler = require("physicsHandler")
CameraHandler = require("cameraHandler")
Camera = require("utilities/cameraUtilities")

ChatHandler = require("chatHandler")
DeckHandler = require("deckHandler")
GameHandler = require("gameHandler") -- Handles the gamified parts of the game, such as score, progress and interface.

local PriorityQueue = require("include/PriorityQueue")

local self = {}
local api = {}

function api.SetMenuState(newState)
	self.menuState = newState
end

function api.ToggleMenu()
	self.menuState = not self.menuState
end

function api.GetPaused()
	return self.paused or self.menuState
end

function api.GetGameOver()
	return self.gameWon or self.gameLost or Global.TEST_WON or Global.TEST_LOST, self.gameWon or Global.TEST_WON, self.gameLost or Global.TEST_LOST, self.overType
end

function api.GetLifetime()
	return self.lifetime
end

function api.Restart()
	self.cosmos.RestartWorld()
end

function api.GetCosmos()
	return self.cosmos
end

function api.getAntHandler()
	return AntHandler
end

function api.SetGameOver(hasWon, overType)
	if self.gameWon or self.gameLost or LevelHandler.GetEditMode() then
		return
	end
	
	if hasWon then
		self.gameWon = true
	else
		self.gameLost = true
		self.overType = overType
	end
end
--------------------------------------------------
-- Input
--------------------------------------------------

function api.KeyPressed(key, scancode, isRepeat)
	if TerrainHandler.KeyPressed and TerrainHandler.KeyPressed(key, scancode, isRepeat) then
		return
	end
	if key == "escape" then
		api.ToggleMenu()
	end
	if key == "p" then
		api.ToggleMenu()
	end
	if GameHandler.KeyPressed and GameHandler.KeyPressed(key, scancode, isRepeat) then
		return
	end
	if ItemHandler.KeyPressed(key, scancode, isRepeat) then
		return
	end
	if LevelHandler.KeyPressed(key, scancode, isRepeat) then
		return
	end
end

function api.MousePressed(x, y, button)
	if ItemHandler.MousePressedPrePause(x, y, button) then
		return
	end
	if api.GetPaused() then
		return
	end
	local uiX, uiY = self.interfaceTransform:inverse():transformPoint(x, y)
	
	if DialogueHandler.MousePressedInterface(uiX, uiY, button) then
		return
	end
	x, y = CameraHandler.GetCameraTransform():inverse():transformPoint(x, y)
	
	-- Send event to game components
	if ItemHandler.MousePressed(x, y, button) then
		return true
	end
	if BlockHandler.MousePressed(x, y, button) then
		return true
	end
	
	if Global.DEBUG_PRINT_CLICK_POS and button == 2 then
		print("{")
		print([[    name = "BLA",]])
		print("    pos = {" .. (math.floor(x/10)*10) .. ", " .. (math.floor(y/10)*10) .. "},")
		print("},")
		return true
	end
end

function api.MouseReleased(x, y, button)
	x, y = CameraHandler.GetCameraTransform():inverse():transformPoint(x, y)
	-- Send event to game components
end

function api.MouseMoved(x, y, dx, dy)
	
end

--------------------------------------------------
-- Transforms
--------------------------------------------------

function api.WorldToScreen(pos)
	local x, y = CameraHandler.GetCameraTransform():transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.ScreenToWorld(pos)
	local x, y = CameraHandler.GetCameraTransform():inverse():transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.ScreenToInterface(pos)
	local x, y = self.interfaceTransform:inverse():transformPoint(pos[1], pos[2])
	return {x, y}
end

function api.GetMousePositionInterface()
	local x, y = love.mouse.getPosition()
	return api.ScreenToInterface({x, y})
end

function api.GetMousePosition()
	local x, y = love.mouse.getPosition()
	return api.ScreenToWorld({x, y})
end

function api.WorldScaleToScreenScale()
	local m11 = CameraHandler.GetCameraTransform():getMatrix()
	return m11
end

function api.GetOrderMult()
	return self.orderMult
end

function api.GetCameraExtents(buffer)
	local screenWidth, screenHeight = love.window.getMode()
	local topLeftPos = api.ScreenToWorld({0, 0})
	local botRightPos = api.ScreenToWorld({screenWidth, screenHeight})
	buffer = buffer or 0
	return topLeftPos[1] - buffer, topLeftPos[2] - buffer, botRightPos[1] + buffer, botRightPos[2] + buffer
end

function api.GetPhysicsWorld()
	return PhysicsHandler.GetPhysicsWorld()
end

local function UpdateCamera(dt)
	CameraHandler.Update(dt, LevelHandler.GetEditMode() and {150, 150, 150, 200})
end

--------------------------------------------------
-- Updates
--------------------------------------------------

function api.ViewResize(width, height)
end

function api.Update(dt)
	GameHandler.Update(dt)
	if api.GetPaused() then
		UpdateCamera(dt)
		return
	end
	
	self.lifetime = self.lifetime + dt
	Delay.Update(dt)
	InterfaceUtil.Update(dt)
	PlayerHandler.Update(dt)
	BlockHandler.Update(dt)
	ItemHandler.Update(dt)
	AntHandler.Update(dt)
	ScentHandler.Update(dt)
	--ShadowHandler.Update(api)
	
	PhysicsHandler.Update(dt)

	ChatHandler.Update(dt)
	EffectsHandler.Update(dt)
	UpdateCamera(dt)
end

function api.Draw()
	local preShadowQueue = PriorityQueue.new(function(l, r) return l.y < r.y end)
	local drawQueue = PriorityQueue.new(function(l, r) return l.y < r.y end)

	-- Draw world
	love.graphics.replaceTransform(CameraHandler.GetCameraTransform())
	while true do
		local d = preShadowQueue:pop()
		if not d then break end
		d.f()
	end
	
	--ShadowHandler.DrawGroundShadow(self.cameraTransform)
	EffectsHandler.Draw(drawQueue)
	PlayerHandler.Draw(drawQueue)
	TerrainHandler.Draw(drawQueue)
	BlockHandler.Draw(drawQueue)
	ItemHandler.Draw(drawQueue)
	AntHandler.Draw(drawQueue)
	ScentHandler.Draw(drawQueue)
	DoodadHandler.Draw(drawQueue)
	LevelHandler.Draw(drawQueue)
	
	love.graphics.replaceTransform(CameraHandler.GetCameraTransform())
	while true do
		local d = drawQueue:pop()
		if not d then break end
		d.f()
	end
	--ShadowHandler.DrawVisionShadow(CameraHandler.GetCameraTransform())
	
	local windowX, windowY = love.window.getMode()
	local aspectRatio = Global.VIEW_WIDTH/Global.VIEW_HEIGHT
	local aspectDifference = windowX/windowY - aspectRatio
	if aspectDifference > 0 then
		-- Wider than tall
		self.interfaceTransform:setTransformation((1 - Global.SHOP_WIDTH / Global.VIEW_WIDTH)*(windowX - windowY*aspectRatio), 0, 0, windowY/Global.VIEW_HEIGHT, windowY/Global.VIEW_HEIGHT, 0, 0)
	else
		-- Taller than wide
		self.interfaceTransform:setTransformation(0, 0.5*(windowY - windowX/aspectRatio), 0, windowX/Global.VIEW_WIDTH, windowX/Global.VIEW_WIDTH, 0, 0)
	end
	love.graphics.replaceTransform(self.interfaceTransform)
	
	-- Draw interface
	GameHandler.DrawInterface()
	EffectsHandler.DrawInterface()
	DialogueHandler.DrawInterface()
	ChatHandler.DrawInterface()
	ItemHandler.DrawInterface()
	LevelHandler.DrawInterface()
	
	love.graphics.replaceTransform(self.emptyTransform)
end

function api.Initialize(cosmos, levelData)
	self = {
	}
	util.SetDefaultWrap(levelData.width, levelData.height)
	
	self.cosmos = cosmos
	self.cameraTransform = love.math.newTransform()
	self.interfaceTransform = love.math.newTransform()
	self.emptyTransform = love.math.newTransform()
	self.paused = false
	self.lifetime = Global.DEBUG_START_LIFETIME or 0
	
	Delay.Initialise()
	InterfaceUtil.Initialize()
	EffectsHandler.Initialize(api)
	
	LevelHandler.Initialize(api, levelData)
	PhysicsHandler.Initialize(api)
	PlayerHandler.Initialize(api)
	ChatHandler.Initialize(api)
	DialogueHandler.Initialize(api)
	
	AntHandler.PreInitialize(api)
	
	TerrainHandler.Initialize(api, levelData)
	ItemHandler.Initialize(api, levelData)
	BlockHandler.Initialize(api)
	AntHandler.Initialize(api)
	ScentHandler.Initialize(api)
	DoodadHandler.Initialize(api)
	--ShadowHandler.Initialize(api)
	
	DeckHandler.Initialize(api)
	GameHandler.Initialize(api)
	
	local padding = {left = 0, right = Global.SHOP_WIDTH / Global.VIEW_WIDTH, top = 0, bot = 0}
	CameraHandler.Initialize(api, levelData, padding)
end

return api
