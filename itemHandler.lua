
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local ItemDefs = require("defs/itemDefs")

local function ApplyRecharge(dt, name)
	local itemDef = ItemDefs.defs[name]
	if itemDef.maxCharges and self.charges[name] < itemDef.maxCharges then
		self.recharge[name] = self.recharge[name] - dt
		if self.recharge[name] < 0 then
			self.charges[name] = self.charges[name] + 1
			self.recharge[name] = self.recharge[name] + itemDef.rechargeTime
		end
	end
end

function api.Update(dt)
	for i = 1, #ItemDefs.itemList do
		ApplyRecharge(dt, ItemDefs.itemList[i])
	end
	
	if self.currentItem ~= "pickup" and self.heldAnt then
		local mousePos = {x, y}
		if AntHandler.DropAnt(mousePos, self.heldAnt) then
			self.heldAnt = false
		end
	end
end

function api.GetCharges(name)
	return self.charges[name]
end

function api.UseCharge(name)
	self.charges[name] = self.charges[name] - 1
end

function api.GetChargeString(name)
	local str = ""
	for i = 1, self.charges[name] do
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
	elseif self.currentItem == "airhorn" then
		drawQueue:push({y=60; f=function()
			local mousePos = self.world.GetMousePosition()
			love.graphics.setColor(0.2, 0.8, 1, 0.5)
			love.graphics.circle("line",
				mousePos[1],
				mousePos[2],
				ItemDefs.defs.airhorn.effectRadius,
				60
			)
		end})
	elseif self.currentItem == "accelerate" then
		drawQueue:push({y=60; f=function()
			local mousePos = self.world.GetMousePosition()
			love.graphics.setColor(0.2, 0.8, 1, 0.5)
			love.graphics.circle("line",
				mousePos[1],
				mousePos[2],
				ItemDefs.defs.accelerate.effectRadius,
				60
			)
		end})
	elseif self.currentItem == "pickup" then
		drawQueue:push({y=60; f=function()
			local mousePos = self.world.GetMousePosition()
			love.graphics.setColor(0.2, 0.8, 1, 0.5)
			love.graphics.circle("line",
				mousePos[1],
				mousePos[2],
				ItemDefs.defs.pickup.effectRadius,
				60
			)
		end})
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
		local mousePos = self.world.GetMousePositionInterface()
		local disabled = itemDef.maxCharges and self.charges[self.currentItem] < 1
		Resources.DrawImage(itemDef.shopImage, mousePos[1], mousePos[2], 0, 0.7, Global.MOUSE_ITEM_SCALE, disabled and {0.65, 0.65, 0.65})
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
		if key == "q" then
			self.currentItem = "editRemove"
		elseif key == "w" then
			self.currentItem = "editPlace"
			self.placeType = "wall"
		elseif key == "e" then
			self.currentItem = "editPlace"
			self.placeType = "wall_90"
		elseif key == "s" then
			self.currentItem = "editPlace"
			self.placeType = "log"
		elseif key == "d" then
			self.currentItem = "editPlace"
			self.placeType = "log_90"
		elseif key == "r" then
			self.currentItem = "editPlace"
			self.placeType = "rug"
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
	elseif self.currentItem == "editPlace" then
		local mousePos = {math.floor((x + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID, math.floor((y + Global.EDIT_GRID/2)/Global.EDIT_GRID)*Global.EDIT_GRID}
		BlockHandler.SpawnBlock(self.placeType, mousePos)
	elseif self.currentItem == "editRemove" then
		local mousePos = {x, y}
		local block = BlockHandler.GetBlockObjectAt(mousePos)
		if block then
			BlockHandler.RemoveBlock(block)
			return true
		end
	elseif self.currentItem == "airhorn" then
		if api.GetCharges("airhorn") > 0 then
			local mousePos = {x, y}
			AntHandler.DoFunctionToAntsInArea("ApplyAirhorn", mousePos, ItemDefs.defs.airhorn.effectRadius)
			api.UseCharge("airhorn")
		end
	elseif self.currentItem == "accelerate" then
		if api.GetCharges("accelerate") > 0 then
			local mousePos = {x, y}
			AntHandler.DoFunctionToAntsInArea("ApplyAcceleration", mousePos, ItemDefs.defs.accelerate.effectRadius)
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