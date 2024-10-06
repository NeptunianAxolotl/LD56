
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local ItemDefs = require("defs/itemDefs")
local EditDefs = require("defs/levelEditorPlacementDef")

local function SnapMousePos(x, y)
	return {math.floor((x + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID, math.floor((y + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID}
end

local function ApplyRecharge(dt, name)
	local itemDef = ItemDefs.defs[name]
	if itemDef.maxCharges and self.charges[name] < itemDef.maxCharges then
		self.recharge[name] = self.recharge[name] - dt
		if self.recharge[name] < 0 then
			self.charges[name] = self.charges[name] + 1
			self.recharge[name] = self.recharge[name] + itemDef.rechargeTime
			if self.charges[name] > itemDef.maxCharges then
				self.charges[name] = itemDef.maxCharges
			end
		end
	end
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
			love.graphics.setColor(0.2, 0.8, 1, 0.5)
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
		if itemDef.effectRadius then
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
end

local function DrawLevelTextAndItems()
	self.hoveredItem = false
	InterfaceUtil.DrawPanel(Global.VIEW_WIDTH - Global.SHOP_WIDTH, -1000, Global.SHOP_WIDTH * 10, Global.VIEW_HEIGHT + 2000, 12)

	local levelData = LevelHandler.GetLevelData()
	love.graphics.setColor(0, 0, 0, 0.8)
	Font.SetSize(2)
	love.graphics.printf(levelData.humanName, Global.VIEW_WIDTH - Global.SHOP_WIDTH, 35, Global.SHOP_WIDTH, "center")
	if levelData.description then
		love.graphics.setColor(0, 0, 0, 0.8)
		Font.SetSize(4)
		love.graphics.printf(levelData.description, Global.VIEW_WIDTH - Global.SHOP_WIDTH + 20, 100, Global.SHOP_WIDTH - 40, "left")
	end
	
	local shopItemsX = Global.VIEW_WIDTH - Global.SHOP_WIDTH*0.5 - 130
	local shopItemsY = 400
	local mousePos = self.world.GetMousePositionInterface()
	
	for i = 1, #levelData.items do
		local name = levelData.items[i]
		local itemDef = ItemDefs.defs[name]
		local disabled = itemDef.maxCharges and self.charges[name] < 1
		self.hoveredItem = InterfaceUtil.DrawButton(shopItemsX, shopItemsY, 120, 120, mousePos, name, disabled, false, false, false, fontOffset, borderThickness) or self.hoveredItem
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
	
	love.graphics.setLineWidth(1)
end

function api.DrawInterface()
	DrawLevelTextAndItems()
	if self.currentItem and not self.currentBlock then
		local itemDef = ItemDefs.defs[self.currentItem]
		if itemDef then
			local mousePos = self.world.GetMousePositionInterface()
			local disabled = itemDef.maxCharges and self.charges[self.currentItem] < 1
			Resources.DrawImage(itemDef.shopImage, mousePos[1], mousePos[2], 0, 0.7, Global.MOUSE_ITEM_SCALE, disabled and {0.65, 0.65, 0.65})
		else
			love.graphics.setColor(1, 0, 0, 0.8)
			Font.SetSize(2)
			love.graphics.printf("Placing: " .. self.currentItem, 20, 20, 8000, "left")
			love.graphics.printf("Type: " .. (self.placeType or "NA"), 20, 60, 8000, "left")
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
		end
		if EditDefs.blocks[key] then
			self.currentItem = "editPlaceBlock"
			self.placeType = EditDefs.blocks[key]
		end
		if EditDefs.nests[key] then
			self.currentItem = "editPlaceNest"
			self.placeType = EditDefs.nests[key]
		end
		if EditDefs.food[key] then
			self.currentItem = "editPlaceFood"
			self.placeType = EditDefs.food[key]
		end
		if EditDefs.spawners[key] then
			self.currentItem = "editPlaceSpawner"
			self.placeType = EditDefs.spawners[key]
		end
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
			if (BlockHandler.FreeToPlaceAt("placement", blockType, mousePos) or LevelHandler.GetEditMode()) then
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
		BlockHandler.SpawnBlock(self.placeType, mousePos)
	elseif self.currentItem == "editPlaceNest" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddNest(self.placeType, mousePos)
	elseif self.currentItem == "editPlaceFood" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddFoodSource(self.placeType, mousePos)
	elseif self.currentItem == "editPlaceSpawner" then
		local mousePos = SnapMousePos(x, y)
		AntHandler.AddSpawner(self.placeType, mousePos)
	elseif self.currentItem == "editRemove" then
		local mousePos = {x, y}
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
	end
end

function api.Initialize(world)
	self = {
		world = world,
		currentItem = "renovate",
		currentBlock = false,
		charges = {},
		recharge = {},
	}
	for i = 1, #ItemDefs.itemList do
		local name = ItemDefs.itemList[i]
		self.charges[name] = 1
		self.recharge[name] = 0
	end
end

return api