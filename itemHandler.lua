
local self = {}
local api = {}

function api.Update(dt)
end

function api.Draw(drawQueue)
	if self.currentItem == "renovate" and self.currentBlock then
		drawQueue:push({y=18; f=function()
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
	end
end

function api.DrawInterface()
	Font.SetSize(2)
	local yOffset = 20
	love.graphics.print("1. Renovation" .. (self.currentItem == "renovate" and " <--" or ""), 90, yOffset)
	yOffset = yOffset + 40
	love.graphics.print("2. Airhorn" .. (self.currentItem == "airhorn" and " <--" or ""), 90, yOffset)
end

function api.KeyPressed(key, scancode, isRepeat)
	if key == "1" then
		self.currentItem = "renovate"
		return true
	end
	if key == "2" then
		self.currentItem = "airhorn"
		return true
	end
end

function api.MousePressed(x, y, button)
	if self.currentItem == "renovate" then
		local mousePos = {x, y}
		if self.currentBlock then
			local blockType = self.currentBlock.def.name
			local blockPos = self.currentBlock.pos
			BlockHandler.RemoveBlock(self.currentBlock)
			if BlockHandler.FreeToPlaceAt("placement", blockType, mousePos) then
				BlockHandler.SpawnBlock(blockType, mousePos)
				self.currentBlock = false
			else
				self.currentBlock = BlockHandler.SpawnBlock(blockType, blockPos)
			end
		else
			local block = BlockHandler.GetBlockObjectAt(mousePos)
			if block then
				self.currentBlock = block
				return true
			end
		end
	end
end

function api.Initialize(world)
	self = {
		world = world,
		currentItem = "renovate",
		currentBlock = false,
	}
end

return api