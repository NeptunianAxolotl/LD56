
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local DoodadDefs = require("defs/doodadDefs")
local ItemDefs = require("defs/itemDefs")
local EditDefs = require("defs/levelEditorPlacementDef")
local SoundHandler = require("soundHandler")

local function SnapMousePos(x, y)
	return {math.floor((x + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID, math.floor((y + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID}
end

local difficultyRechargeMap = {
	1.6,
	1,
	0.75,
	0.5,
}

local moddedMaxChargesDifficultyMod = {
	1.2,
	1,
	0.75,
	0.45,
}

local function GetMaxCharges(name)
	local maxCharges = (ItemDefs.defs[name].maxCharges or 1)
	if self.levelData.maxItemMod then
		maxCharges = math.floor(1 + maxCharges * (self.levelData.maxItemMod[name] or 1) * moddedMaxChargesDifficultyMod[self.world.GetDifficulty()])
	end
	return maxCharges
end

local function GetRechargeTimeMod(name)
	local recharge = (LevelHandler.GetLevelData().tweaks.itemRechargeMult or 1) * difficultyRechargeMap[self.world.GetDifficulty()]
	if self.levelData.itemRechargeMod then
		recharge = recharge * (self.levelData.itemRechargeMod[name] or 1)
	end
	return recharge
end

local function ApplyRecharge(dt, name)
	local itemDef = ItemDefs.defs[name]
	if itemDef.maxCharges and self.charges[name] < GetMaxCharges(name) then
		self.recharge[name] = self.recharge[name] - dt * GetRechargeTimeMod(name)
		if self.recharge[name] < 0 then
			self.charges[name] = self.charges[name] + 1
			self.recharge[name] = self.recharge[name] + itemDef.rechargeTime
			if self.charges[name] > GetMaxCharges(name) then
				self.charges[name] = GetMaxCharges(name)
			end
		end
	end
end

local function MaybeRotatePlacement(defName)
	if not EditDefs.rotateable[defName] then
		return defName
	end
	return defName .. "_" .. self.placeRotation
end

local function CheckPaintItem(name, mousePos)
	local levelData = LevelHandler.GetLevelData()
	if mousePos[1] < 0 or mousePos[2] < 0 or mousePos[1] > levelData.width or mousePos[2] > levelData.height then
		return false
	end
	local itemDef = ItemDefs.defs[name]
	if api.GetCharges(name) <= 0 then
		return false
	end
	if self.lastPaintPos then
		if util.Dist(self.lastPaintPos, mousePos) < itemDef.paintSpacing then
			return false
		end
	end
	self.lastPaintPos = mousePos
	return true
end

local function DropScentCheck()
	local mousePos = self.world.GetMousePosition()
	if CheckPaintItem("scent", mousePos) then
		local itemDef = ItemDefs.defs["scent"]
		ScentHandler.AddScent("explore", mousePos, itemDef.effectRadius, itemDef.scentStrength)
		ScentHandler.AddScent("food", mousePos, itemDef.effectRadius, itemDef.scentStrength)
		api.UseCharge("scent")
    SoundHandler.PlaySound("scent", false, 0, 0, false, false, 1, true)
	end
end

local function MopScentCheck()
	local mousePos = self.world.GetMousePosition()
	if CheckPaintItem("mop", mousePos) then
		local itemDef = ItemDefs.defs["mop"]
		ScentHandler.AddScent("explore", mousePos, itemDef.effectRadius, -itemDef.mopStrength)
		ScentHandler.AddScent("food", mousePos, itemDef.effectRadius, -itemDef.mopStrength)
		api.UseCharge("mop")
    SoundHandler.PlaySound("mop", false, 0, 0, false, false, 1, true)
	end
end

function api.Update(dt)
	if not GameHandler.GetLevelBegun() then
		dt = dt*0.05
	end
	for i = 1, #ItemDefs.itemList do
		ApplyRecharge(dt, ItemDefs.itemList[i])
	end
	
	if self.heldAnt and self.heldAnt.destroyed then
		self.heldAnt = false
	end
	
	if self.currentItem ~= "pickup" and self.heldAnt then
		local mousePos = self.world.GetMousePosition()
		if AntHandler.DropAnt(mousePos, self.heldAnt) then
			self.heldAnt = false
		end
	end
	if self.currentItem == "scent" and love.mouse.isDown(1) then
		DropScentCheck()
	end
	if self.currentItem == "mop" and love.mouse.isDown(1) then
		MopScentCheck()
	end
end

function api.GetCharges(name)
	return self.charges[name]
end

function api.UseCharge(name)
	local itemDef = ItemDefs.defs[name]
	self.charges[name] = self.charges[name] - (itemDef.useRate or 1)
end

function api.GetChargeString(name)
	local str = ""
	for i = 1, math.floor(self.charges[name] + 0.9) do
		str = str .. "#"
	end
	return str
end

local function CanPlaceBlock(def, pos)
	if not BlockHandler.FreeToPlaceAt("placement", def.name, pos) then
		return false
	end
	if AntHandler.IsGroundCreatureInRectangle(pos, def.width + 40, def.height + 40) then
		return false
	end
	return true
end

function api.SetCurrentItem(newItem)
	if newItem then
		GameHandler.BeginLevel()
	end
	self.currentItem = newItem
end

function api.ReplaceActiveItem()
	api.SetCurrentItem(false)
	self.currentBlock = false
end

function api.Draw(drawQueue)
	if self.currentItem == "renovate" and self.currentBlock then
		drawQueue:push({y=60; f=function()
			love.graphics.setColor(0.7, 0.8, 0.2, 0.5)
			love.graphics.rectangle("fill",
				self.currentBlock.pos[1] - self.currentBlock.def.width/2,
				self.currentBlock.pos[2] - self.currentBlock.def.height/2,
				self.currentBlock.def.width,
				self.currentBlock.def.height
			)
			local mousePos = self.world.GetMousePosition()
			BlockHandler.RemoveFromBlockCache(self.currentBlock)
			if CanPlaceBlock(self.currentBlock.def, mousePos) then
				love.graphics.setColor(0.2, 0.8, 1, 0.5)
			else
				love.graphics.setColor(1, 0.1, 0.1, 0.5)
			end
			BlockHandler.AddToBlockCache(self.currentBlock)
			
			love.graphics.rectangle("fill",
				mousePos[1] - self.currentBlock.def.width/2,
				mousePos[2] - self.currentBlock.def.height/2,
				self.currentBlock.def.width,
				self.currentBlock.def.height
			)
		end})
	elseif self.currentItem == "editPlace" then
		drawQueue:push({y=60; f=function()
			local placeDef = BlockDefs.defs[self.placeType]
			local mousePos = self.world.GetMousePosition()
			mousePos[1] = math.floor((mousePos[1] + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID
			mousePos[2] = math.floor((mousePos[2] + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID
			love.graphics.setColor(0.2, 0.8, 1, 0.5)
			love.graphics.rectangle("fill",
				mousePos[1] - placeDef.width/2,
				mousePos[2] - placeDef.height/2,
				placeDef.width,
				placeDef.height
			)
		end})
	end
	if self.currentItem then
		local itemDef = ItemDefs.defs[self.currentItem]
		if itemDef and itemDef.effectRadius then
			drawQueue:push({y=60; f=function()
				local mousePos = self.world.GetMousePosition()
				love.graphics.setColor(0.2, 0.8, 1, 0.5)
				love.graphics.circle("line",
					mousePos[1],
					mousePos[2],
					itemDef.effectRadius,
					60
				)
			end})
		end
	end
	if self.currentItem == "editPlaceBlock" then
		local placeDef = BlockDefs.defs[MaybeRotatePlacement(self.placeType)]
		drawQueue:push({y=200000; f=function()
			local mousePos = self.world.GetMousePosition()
			local mousePos = SnapMousePos(mousePos[1], mousePos[2])
			love.graphics.setColor(1, 1, 1, 1)
			love.graphics.setLineWidth(4)
			love.graphics.rectangle("line", mousePos[1] - placeDef.width/2, mousePos[2] - placeDef.height/2, placeDef.width, placeDef.height)
			love.graphics.setLineWidth(1)
			if placeDef.image then
				DoodadHandler.DrawDoodad(placeDef, mousePos, 0.5)
			end
		end})
	elseif self.currentItem == "editPlaceDoodad" then
		local placeDef = DoodadDefs.defs[MaybeRotatePlacement(self.placeType)]
		drawQueue:push({y=200000; f=function()
			local mousePos = self.world.GetMousePosition()
			local mousePos = SnapMousePos(mousePos[1], mousePos[2])
			DoodadHandler.DrawDoodad(placeDef, mousePos, 0.5)
		end})
	end
end

local function DrawLevelTextAndItems()
	InterfaceUtil.DrawPanel(Global.VIEW_WIDTH - Global.SHOP_WIDTH, -1000, Global.SHOP_WIDTH * 10, Global.VIEW_HEIGHT + 2000, 12)

	local levelData = LevelHandler.GetLevelData()
	love.graphics.setColor(0, 0, 0, 0.8)
	Font.SetSize(2)
	love.graphics.printf(levelData.humanName, Global.VIEW_WIDTH - Global.SHOP_WIDTH, 35, Global.SHOP_WIDTH, "center")
	if levelData.description then
		love.graphics.setColor(0, 0, 0, 0.8)
		Font.SetSize(3)
		love.graphics.printf(levelData.description, Global.VIEW_WIDTH - Global.SHOP_WIDTH + 20, 100, Global.SHOP_WIDTH - 10, "left")
	end
	
	if LevelHandler.GetEditMode() then
		love.graphics.setColor(0, 0, 0, 0.8)
		Font.SetSize(3)
		love.graphics.printf("Welcome to edit mode. Keyboard keys select items. Press all of them and check the top left to see what they do.\n - Q deletes blocks\n - Z and X rotates some blocks\n - The numpad contains creature spawners, food, and nests.\n\nLevel dimension and items are edited in the file manually.\n\nPress Ctrl+E to leave edit mode.", Global.VIEW_WIDTH - Global.SHOP_WIDTH + 20, 420, Global.SHOP_WIDTH - 10, "left")
		return
	end
	
	local gameOver, won, lost = self.world.GetGameOver()
	if gameOver then
		return
	end
	
	local shopItemsX = Global.VIEW_WIDTH - Global.SHOP_WIDTH*0.5 - 130
	local shopItemsY = 420
	local mousePos = self.world.GetMousePositionInterface()
	
	for i = 1, #levelData.items do
		local name = levelData.items[i]
		local itemDef = ItemDefs.defs[name]
		local selectedItem = self.currentItem == name
		self.hoveredItem = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 120, 120, mousePos, name, selectedItem, false, true, false, false, false) or self.hoveredItem
		if not selectedItem then
			Resources.DrawImage(itemDef.shopImage, shopItemsX + 60, shopItemsY + 60, 0, 1, Global.SHOP_IMAGE_SCALE)
		end
		if itemDef.maxCharges then
			love.graphics.setColor(0.3, 0.3, 0.3, 0.8)
			love.graphics.print(api.GetChargeString(name), shopItemsX + 8, shopItemsY + 90)
		end
		if i%2 == 1 then
			shopItemsX = shopItemsX + 140
		else
			shopItemsX = shopItemsX - 140
			shopItemsY = shopItemsY + 140
		end
	end
end

local function DrawLevelVictoryState()
	local gameOver, won, lost = self.world.GetGameOver()
	if not gameOver or LevelHandler.GetEditMode() then
		return
	end
	local levelData = LevelHandler.GetLevelData()
	local shopItemsX = Global.VIEW_WIDTH - Global.SHOP_WIDTH*0.5 - 110
	local shopItemsY = 855 + 30
	local mousePos = self.world.GetMousePositionInterface()
	
	if won then
		love.graphics.setColor(0, 0, 0, 0.8)
		Font.SetSize(3)
		love.graphics.printf(levelData.gameWon or "The ants have been removed.", Global.VIEW_WIDTH - Global.SHOP_WIDTH + 20, 520, Global.SHOP_WIDTH - 10, "left")
		self.hoveredMenuAction = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 220, 75, mousePos, "Next Level", false, true, false, 2, 12, false) or self.hoveredMenuAction
	end
	if lost then
		love.graphics.printf(levelData.gameLost or "The ants ate too much food. Press Ctrl+R to restart.", Global.VIEW_WIDTH - Global.SHOP_WIDTH + 20, 520, Global.SHOP_WIDTH - 10, "left")
		self.hoveredMenuAction = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 220, 75, mousePos, "Restart", false, true, false, 2, 12, false) or self.hoveredMenuAction
	end
end

local function DrawMenu()
	local shopItemsX = Global.VIEW_WIDTH - Global.SHOP_WIDTH*0.5 - 110
	local shopItemsY = 950 + 30
	local mousePos = self.world.GetMousePositionInterface()
	self.hoveredMenuAction = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 220, 75, mousePos, "Menu", false, false, false, 2, 12, false) or self.hoveredMenuAction

	if not self.world.GetPaused() then
		return
	end

	local buttons = 11
	local sections = 3
	
	if LevelHandler.GetEditMode() then
		buttons = buttons - 1
	end
	
	local overWidth = Global.VIEW_WIDTH*0.16
	local overHeight = buttons*55 + sections*20 - 55
	local overX = Global.VIEW_WIDTH*0.6
	local overY = Global.VIEW_HEIGHT - overHeight - 150
	InterfaceUtil.DrawPanel(overX, overY, overWidth, overHeight*1.12)
	
	local offset = overY + 20
	if LevelHandler.GetEditMode() then
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Save Level", false, false, false, 3, 8, 4) or self.hoveredMenuAction
		offset = offset + 55
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Load Level", false, false, false, 3, 8, 4) or self.hoveredMenuAction
		offset = offset + 55
	else
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Toggle Music", false, false, false, 3, 8, 4) or self.hoveredMenuAction
		offset = offset + 55
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Music Louder", false, false, false, 3, 8, 4) or self.hoveredMenuAction
		offset = offset + 55
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Music Softer", false, false, false, 3, 8, 4) or self.hoveredMenuAction
		offset = offset + 55
	end
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Toggle Editor", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	offset = offset + 55
	
	offset = offset + 20
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Restart", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	offset = offset + 55
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Next Level", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	offset = offset + 55
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Previous Level", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	offset = offset + 55
	local difficulty = self.world.GetCosmos().GetDifficulty()
	if difficulty == 1 then
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Hard Mode", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	elseif difficulty == 2 then
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Harder Mode", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	elseif difficulty == 3 then
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Insane Mode", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	elseif difficulty == 4 then
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Reset Difficulty", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	end
	offset = offset + 55
	
	local offset = overY + overHeight
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Quit", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	offset = offset - 55
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Resume", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	offset = offset - 55
	if GameHandler.GetSandboxMode() then
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Sandbox Mode: On", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	else
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Sandbox Mode: Off", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	end
end

function api.DrawInterface()
	self.hoveredItem = false
	self.hoveredMenuAction = false
	
	DrawLevelTextAndItems()
	DrawLevelVictoryState()
	DrawMenu()
	if self.currentItem and not self.currentBlock then
		local itemDef = ItemDefs.defs[self.currentItem]
		if itemDef then
			local mousePos = self.world.GetMousePositionInterface()
			local disabled = itemDef.maxCharges and self.charges[self.currentItem] < 1
			Resources.DrawImage(itemDef.shopImage, mousePos[1], mousePos[2], 0, 0.7, Global.MOUSE_ITEM_SCALE, disabled and {0.65, 0.65, 0.65})
		else
			love.graphics.setColor(1, 1, 1, 1)
			Font.SetSize(2)
			love.graphics.printf("Placing: " .. self.currentItem, 20, 20, 8000, "left")
			love.graphics.printf("Type: " .. (MaybeRotatePlacement(self.placeType) or "NA"), 20, 60, 8000, "left")
		end
	end
end

function api.KeyPressed(key, scancode, isRepeat)
	if LevelHandler.GetEditMode() then
		if key == EditDefs.deletionKey then
			api.SetCurrentItem("editRemove")
			self.placeType = false
			return true
		elseif key == EditDefs.rotationKey then
			self.placeRotation = (self.placeRotation + 90)%360
			return true
		elseif key == EditDefs.otherRotateKey then
			self.placeRotation = (self.placeRotation - 90)%360
			return true
		elseif EditDefs.blocks[key] then
			api.SetCurrentItem("editPlaceBlock")
			self.placeType = EditDefs.blocks[key]
			return true
		elseif EditDefs.nests[key] then
			api.SetCurrentItem("editPlaceNest")
			self.placeType = EditDefs.nests[key]
			return true
		elseif EditDefs.food[key] then
			api.SetCurrentItem("editPlaceFood")
			self.placeType = EditDefs.food[key]
			return true
		elseif EditDefs.spawners[key] then
			api.SetCurrentItem("editPlaceSpawner")
			self.placeType = EditDefs.spawners[key]
			return true
		elseif EditDefs.doodads[key] then
			api.SetCurrentItem("editPlaceDoodad")
			self.placeType = EditDefs.doodads[key]
			return true
		end
	end
	local number = key and (tonumber(key) or tonumber(string.sub(key, 3, 3)))
	if number then
		local levelData = LevelHandler.GetLevelData()
		if levelData.items[number] then
			api.SetCurrentItem(levelData.items[number])
			return true
		end
	end
end

function HandleHoveredMenuAction()
	api.ReplaceActiveItem()
	if self.hoveredMenuAction == "Menu" then
		self.world.ToggleMenu()
	elseif self.hoveredMenuAction == "Toggle Music" then
		self.world.GetCosmos().ToggleMusic()
	elseif self.hoveredMenuAction == "Music Louder" then
		self.world.GetCosmos().MusicLouder()
	elseif self.hoveredMenuAction == "Music Softer" then
		self.world.GetCosmos().MusicSofter()
	elseif self.hoveredMenuAction == "Hard Mode" then
		self.world.GetCosmos().SetDifficulty(2)
	elseif self.hoveredMenuAction == "Harder Mode" then
		self.world.GetCosmos().SetDifficulty(3)
	elseif self.hoveredMenuAction == "Insane Mode" then
		self.world.GetCosmos().SetDifficulty(4)
	elseif self.hoveredMenuAction == "Reset Difficulty" then
		self.world.GetCosmos().SetDifficulty(1)
	elseif self.hoveredMenuAction == "Sandbox Mode: On" or self.hoveredMenuAction == "Sandbox Mode: Off" then
		GameHandler.ToggleSandboxMode()
	elseif self.hoveredMenuAction == "Save Level" then
		LevelHandler.OpenSaveMenu()
	elseif self.hoveredMenuAction == "Load Level" then
		LevelHandler.OpenLoadMenu()
	elseif self.hoveredMenuAction == "Restart" then
		self.world.Restart()
	elseif self.hoveredMenuAction == "Next Level" then
		self.world.GetCosmos().SwitchLevel(true)
	elseif self.hoveredMenuAction == "Previous Level" then
		self.world.GetCosmos().SwitchLevel(false)
	elseif self.hoveredMenuAction == "Toggle Editor" then
		LevelHandler.ToggleEditMode()
	elseif self.hoveredMenuAction == "Resume" then
		self.world.SetMenuState(false)
	elseif self.hoveredMenuAction == "Quit" then
		love.event.quit()
	end
end

function api.MousePressedPrePause(x, y, button)
	if self.hoveredMenuAction then
		HandleHoveredMenuAction()
		return
	end
end

function api.MousePressed(x, y, button)
	if self.hoveredItem then
		if self.currentItem == self.hoveredItem then
			api.SetCurrentItem(false)
		else
			api.SetCurrentItem(self.hoveredItem)
		end
		self.currentBlock = false
		return
	end
	
	if self.currentItem == "renovate" then
		local mousePos = {x, y}
		if self.currentBlock then
			local blockType = self.currentBlock.def.name
			local blockPos = self.currentBlock.pos
			BlockHandler.RemoveBlock(self.currentBlock)
			if CanPlaceBlock(self.currentBlock.def, mousePos) or LevelHandler.GetEditMode() then
				BlockHandler.SpawnBlock(blockType, mousePos)
        SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
				self.currentBlock = false
			else
				self.currentBlock = BlockHandler.SpawnBlock(blockType, blockPos)
			end
		else
			local block = BlockHandler.GetBlockObjectAt(mousePos)
			if block and (block.def.canBeMoved or LevelHandler.GetEditMode()) then
				self.currentBlock = block
				return true
			end
		end
	elseif self.currentItem == "editPlaceBlock" then
		local mousePos = SnapMousePos(x, y)
		BlockHandler.SpawnBlock(MaybeRotatePlacement(self.placeType), mousePos)
    SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
	elseif self.currentItem == "editPlaceNest" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddNest(MaybeRotatePlacement(self.placeType), mousePos)
    SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
	elseif self.currentItem == "editPlaceFood" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddFoodSource(MaybeRotatePlacement(self.placeType), mousePos)
    SoundHandler.PlaySound("food_drop", false, 0, 0, false, false, 1, true)
	elseif self.currentItem == "editPlaceSpawner" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddSpawner(MaybeRotatePlacement(self.placeType), mousePos)
    SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
	elseif self.currentItem == "editPlaceDoodad" then
		local mousePos = SnapMousePos(x, y)
		DoodadHandler.AddDoodad(MaybeRotatePlacement(self.placeType), mousePos)
    SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
	elseif self.currentItem == "editRemove" then
		local mousePos = {x, y}
		if DoodadHandler.RemoveDoodads(mousePos) then
      SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
			return true
		end
		local block = BlockHandler.GetBlockObjectAt(mousePos)
		if block then
			BlockHandler.RemoveBlock(block)
      SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
			return true
		end
		AntHandler.DeleteObjectAt(mousePos)
    SoundHandler.PlaySound("hammer", false, 0, 0, false, false, 1, true)
	elseif self.currentItem == "airhorn" then
		if api.GetCharges("airhorn") > 0 then
			local mousePos = {x, y}
			AntHandler.DoFunctionToAntsInArea("ApplyAirhorn", mousePos, ItemDefs.defs.airhorn.effectRadius)
			AntHandler.DoFunctionToCreaturesInArea("ApplyAirhorn", mousePos, ItemDefs.defs.airhorn.effectRadius)
			api.UseCharge("airhorn")
      SoundHandler.PlaySound("airhorn", false, 0, 0, false, false, 1, true)
		end
	elseif self.currentItem == "accelerate" then
		if api.GetCharges("accelerate") > 0 then
			local mousePos = {x, y}
			AntHandler.DoFunctionToAntsInArea("ApplyAcceleration", mousePos, ItemDefs.defs.accelerate.effectRadius)
			AntHandler.DoFunctionToCreaturesInArea("ApplyAcceleration", mousePos, ItemDefs.defs.accelerate.effectRadius)
			api.UseCharge("accelerate")
      SoundHandler.PlaySound("food_drop", false, 0, 0, false, false, 1, true)
		end
	elseif self.currentItem == "pickup" then
		local mousePos = {x, y}
		if self.heldAnt then
			if AntHandler.DropAnt(mousePos, self.heldAnt) then
				self.heldAnt = false
        SoundHandler.PlaySound("food_drop", false, 0, 0, false, false, 1, true)
			end
		elseif api.GetCharges("pickup") > 0 then
			self.heldAnt = AntHandler.PickupAnt(mousePos, ItemDefs.defs.pickup.effectRadius)
			if self.heldAnt then
				api.UseCharge("pickup")
        SoundHandler.PlaySound("food_drop", false, 0, 0, false, false, 1, true)
			end
		end
	elseif self.currentItem == "scent" then
		self.lastPaintPos = false
		DropScentCheck()
	elseif self.currentItem == "nop" then
		self.lastPaintPos = false
		MopScentCheck()
	elseif self.currentItem == "place_food" then
		if api.GetCharges("place_food") > 0 then
			local itemDef = ItemDefs.defs[self.currentItem]
			local mousePos = {x, y}
			AntHandler.AddFoodSource(itemDef.placeFoodType, mousePos)
			api.UseCharge("place_food")
      SoundHandler.PlaySound("food_drop", false, 0, 0, false, false, 1, true)
		end
	end
end

function api.Initialize(world, levelData)
	self = {
		world = world,
		currentItem = false,
		currentBlock = false,
		placeRotation = 90,
		charges = {},
		recharge = {},
		levelData = levelData,
	}
	for i = 1, #ItemDefs.itemList do
		local name = ItemDefs.itemList[i]
		self.charges[name] = math.floor(GetMaxCharges(name) * (levelData.tweaks.initialItemsProp or 1))
		self.recharge[name] = 0
	end
end

return api