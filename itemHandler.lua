
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local DoodadDefs = require("defs/doodadDefs")
local ItemDefs = require("defs/itemDefs")
local EditDefs = require("defs/levelEditorPlacementDef")

local function SnapMousePos(x, y)
	return {math.floor((x + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID, math.floor((y + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID}
end

local function ApplyRecharge(dt, name)
	local itemDef = ItemDefs.defs[name]
	if itemDef.maxCharges and self.charges[name] < itemDef.maxCharges then
		local itemRechargeMult = LevelHandler.GetLevelData().itemRechargeMult
		self.recharge[name] = self.recharge[name] - dt * itemRechargeMult
		if self.recharge[name] < 0 then
			self.charges[name] = self.charges[name] + 1
			self.recharge[name] = self.recharge[name] + itemDef.rechargeTime
			if self.charges[name] > itemDef.maxCharges then
				self.charges[name] = itemDef.maxCharges
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
	end
end

local function MopScentCheck()
	local mousePos = self.world.GetMousePosition()
	if CheckPaintItem("mop", mousePos) then
		local itemDef = ItemDefs.defs["mop"]
		ScentHandler.AddScent("explore", mousePos, itemDef.effectRadius, -itemDef.mopStrength)
		ScentHandler.AddScent("food", mousePos, itemDef.effectRadius, -itemDef.mopStrength)
		api.UseCharge("mop")
	end
end

function api.Update(dt)
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

function api.EditModeToggled()
	self.currentItem = false
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
			if CanPlaceBlock(self.currentBlock.def, mousePos) then
				love.graphics.setColor(0.2, 0.8, 1, 0.5)
			else
				love.graphics.setColor(1, 0.1, 0.1, 0.5)
			end
			
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
	
	local gameOver, won, lost = self.world.GetGameOver()
	if gameOver then
		return
	end
	
	local shopItemsX = Global.VIEW_WIDTH - Global.SHOP_WIDTH*0.5 - 130
	local shopItemsY = 400
	local mousePos = self.world.GetMousePositionInterface()
	
	for i = 1, #levelData.items do
		local name = levelData.items[i]
		local itemDef = ItemDefs.defs[name]
		local disabled = itemDef.maxCharges and self.charges[name] < 1
		self.hoveredItem = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 120, 120, mousePos, name, disabled, false, false, false, false, false) or self.hoveredItem
		if self.currentItem ~= name then
			Resources.DrawImage(itemDef.shopImage, shopItemsX + 60, shopItemsY + 60, 0, 1, Global.SHOP_IMAGE_SCALE)
		end
		if itemDef.maxCharges then
			love.graphics.setColor(0.3, 0.3, 0.3, 0.8)
			love.graphics.print(api.GetChargeString(name), shopItemsX + 10, shopItemsY + 90)
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
	local shopItemsY = 855
	local mousePos = self.world.GetMousePositionInterface()
	
	if won then
		love.graphics.setColor(0, 0, 0, 0.8)
		Font.SetSize(3)
		love.graphics.printf(levelData.gameWon or "The ants have been removed.", Global.VIEW_WIDTH - Global.SHOP_WIDTH + 20, 700, Global.SHOP_WIDTH - 10, "left")
		self.hoveredMenuAction = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 220, 75, mousePos, "Next Level", false, true, false, 2, 12, false) or self.hoveredMenuAction
	end
	if lost then
		love.graphics.printf(levelData.gameOver or "The ants ate too much food. Press Ctrl+R to restart.", Global.VIEW_WIDTH - Global.SHOP_WIDTH + 20, 700, Global.SHOP_WIDTH - 10, "left")
		self.hoveredMenuAction = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 220, 75, mousePos, "Restart", false, true, false, 2, 12, false) or self.hoveredMenuAction
	end
end

local function DrawMenu()
	local shopItemsX = Global.VIEW_WIDTH - Global.SHOP_WIDTH*0.5 - 110
	local shopItemsY = 950
	local mousePos = self.world.GetMousePositionInterface()
	self.hoveredMenuAction = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 220, 75, mousePos, "Menu", false, false, false, 2, 12, false) or self.hoveredMenuAction

	if not self.world.GetPaused() then
		return
	end

	local buttons = 11
	local sections = 3
	
	if LevelHandler.GetEditMode() then
		buttons = buttons - 3
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
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Effects Louder", false, false, false, 3, 8, 4) or self.hoveredMenuAction
		offset = offset + 55
		self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Effects Softer", false, false, false, 3, 8, 4) or self.hoveredMenuAction
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
	
	local offset = overY + overHeight
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Quit", false, false, false, 3, 8, 4) or self.hoveredMenuAction
	offset = offset - 55
	self.hoveredMenuAction = InterfaceUtil.DrawButton(overX + 20, offset, 270, 45, mousePos, "Resume", false, false, false, 3, 8, 4) or self.hoveredMenuAction
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
	if tonumber(key) then
		local levelData = LevelHandler.GetLevelData()
		if levelData.items[tonumber(key)] then
			self.currentItem = levelData.items[tonumber(key)]
			return true
		end
	end
	if LevelHandler.GetEditMode() then
		if key == EditDefs.deletionKey then
			self.currentItem = "editRemove"
			self.placeType = false
		elseif key == EditDefs.rotationKey then
			self.placeRotation = (self.placeRotation + 90)%360
		elseif key == EditDefs.otherRotateKey then
			self.placeRotation = (self.placeRotation - 90)%360
		elseif EditDefs.blocks[key] then
			self.currentItem = "editPlaceBlock"
			self.placeType = EditDefs.blocks[key]
		elseif EditDefs.nests[key] then
			self.currentItem = "editPlaceNest"
			self.placeType = EditDefs.nests[key]
		elseif EditDefs.food[key] then
			self.currentItem = "editPlaceFood"
			self.placeType = EditDefs.food[key]
		elseif EditDefs.spawners[key] then
			self.currentItem = "editPlaceSpawner"
			self.placeType = EditDefs.spawners[key]
		elseif EditDefs.doodads[key] then
			self.currentItem = "editPlaceDoodad"
			self.placeType = EditDefs.doodads[key]
		end
	end
end

function HandleHoveredMenuAction()
	if self.hoveredMenuAction == "Menu" then
		self.world.ToggleMenu()
	elseif self.hoveredMenuAction == "Toggle Music" then
		
	elseif self.hoveredMenuAction == "Music Louder" then
		
	elseif self.hoveredMenuAction == "Music Softer" then
		
	elseif self.hoveredMenuAction == "Effects Louder" then
		
	elseif self.hoveredMenuAction == "Effects Louder" then
		
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
			self.currentItem = false
		else
			self.currentItem = self.hoveredItem
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
	elseif self.currentItem == "editPlaceNest" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddNest(MaybeRotatePlacement(self.placeType), mousePos)
	elseif self.currentItem == "editPlaceFood" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddFoodSource(MaybeRotatePlacement(self.placeType), mousePos)
	elseif self.currentItem == "editPlaceSpawner" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddSpawner(MaybeRotatePlacement(self.placeType), mousePos)
	elseif self.currentItem == "editPlaceDoodad" then
		local mousePos = SnapMousePos(x, y)
		DoodadHandler.AddDoodad(MaybeRotatePlacement(self.placeType), mousePos)
	elseif self.currentItem == "editRemove" then
		local mousePos = {x, y}
		if DoodadHandler.RemoveDoodads(mousePos) then
			return true
		end
		local block = BlockHandler.GetBlockObjectAt(mousePos)
		if block then
			BlockHandler.RemoveBlock(block)
			return true
		end
		AntHandler.DeleteObjectAt(mousePos)
	elseif self.currentItem == "airhorn" then
		if api.GetCharges("airhorn") > 0 then
			local mousePos = {x, y}
			AntHandler.DoFunctionToAntsInArea("ApplyAirhorn", mousePos, ItemDefs.defs.airhorn.effectRadius)
			AntHandler.DoFunctionToCreaturesInArea("ApplyAirhorn", mousePos, ItemDefs.defs.airhorn.effectRadius)
			api.UseCharge("airhorn")
		end
	elseif self.currentItem == "accelerate" then
		if api.GetCharges("accelerate") > 0 then
			local mousePos = {x, y}
			AntHandler.DoFunctionToAntsInArea("ApplyAcceleration", mousePos, ItemDefs.defs.accelerate.effectRadius)
			AntHandler.DoFunctionToCreaturesInArea("ApplyAcceleration", mousePos, ItemDefs.defs.accelerate.effectRadius)
			api.UseCharge("accelerate")
		end
	elseif self.currentItem == "pickup" then
		local mousePos = {x, y}
		if self.heldAnt then
			if AntHandler.DropAnt(mousePos, self.heldAnt) then
				self.heldAnt = false
			end
		elseif api.GetCharges("pickup") > 0 then
			self.heldAnt = AntHandler.PickupAnt(mousePos, ItemDefs.defs.pickup.effectRadius)
			if self.heldAnt then
				api.UseCharge("pickup")
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
	}
	for i = 1, #ItemDefs.itemList do
		local name = ItemDefs.itemList[i]
		self.charges[name] = math.floor((ItemDefs.defs[name].maxCharges or 1) * (levelData.initialItemsProp))
		self.recharge[name] = 0
	end
end

return api