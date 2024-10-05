
local self = {}
local api = {}

local BlockDefs = require("defs/blockDefs")
local ItemDefs = require("defs/itemDefs")

local function ApplyRecharge(dt, name)
	if self.charges[name] < Global.MAX_CHARGES[name] then
		self.recharge[name] = self.recharge[name] - dt
		if self.recharge[name] < 0 then
			self.charges[name] = self.charges[name] + 1
			self.recharge[name] = Global.RECHARGE_TIME[name]
		end
	end
end

function api.Update(dt)
	for i = 1, #ItemDefs.itemList do
		ApplyRecharge(dt, ItemDefs.itemList[i])
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
				Global.AIRHORN_RADIUS,
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
				Global.ACCELERATE_RADIUS,
				60
			)
		end})
	end
end

function api.DrawInterface()
	Font.SetSize(2)
	local yOffset = 20
	love.graphics.setColor(0, 0, 0, 1)
	love.graphics.print("1. Renovation" .. (self.currentItem == "renovate" and " <--" or ""), 90, yOffset)
	yOffset = yOffset + 40
	
	if api.GetCharges("airhorn") == 0 then
		love.graphics.setColor(0.4, 0.4, 0.4, 1)
	else
		love.graphics.setColor(0, 0, 0, 1)
	end
	love.graphics.print("2. Airhorn " .. api.GetChargeString("airhorn") .. (self.currentItem == "airhorn" and " <--" or ""), 90, yOffset)
	yOffset = yOffset + 40
	
	if api.GetCharges("accelerate") == 0 then
		love.graphics.setColor(0.4, 0.4, 0.4, 1)
	else
		love.graphics.setColor(0, 0, 0, 1)
	end
	love.graphics.print("3. Drugs? " .. api.GetChargeString("accelerate") .. (self.currentItem == "accelerate" and " <--" or ""), 90, yOffset)
end

function api.KeyPressed(key, scancode, isRepeat)
	if key == "1" then
		self.currentItem = "renovate"
		return true
	elseif key == "2" then
		self.currentItem = "airhorn"
		return true
	elseif key == "3" then
		self.currentItem = "accelerate"
		return true
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
			AntHandler.DoFunctionToAntsInArea("ApplyAirhorn", mousePos, Global.AIRHORN_RADIUS)
			api.UseCharge("airhorn")
		end
	elseif self.currentItem == "accelerate" then
		if api.GetCharges("accelerate") > 0 then
			local mousePos = {x, y}
			AntHandler.DoFunctionToAntsInArea("ApplyAcceleration", mousePos, Global.AIRHORN_RADIUS)
			api.UseCharge("accelerate")
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
		self.charges[name] = 0
		self.recharge[name] = Global.RECHARGE_TIME[name]
	end
end

return api