
local Font = require("include/font")

MusicHandler = require("musicHandler")
BGMHandler = require("bgmHandler") -- Uncomment when I have the remotest confidence this works - LWG

local ItemDefs = require("defs/itemDefs")

local self = {}
local api = {}

--------------------------------------------------
-- Difficulty Etc
--------------------------------------------------


local difficultyRechargeMap = {
	1.6,
	1,
	0.75,
	0.5,
	0.5,
	0.35,
}

local moddedMaxChargesDifficultyMod = {
	1.2,
	1,
	0.75,
	0.45,
	1,
	1,
}

local generalMaxChargesDifficultyMod = {
	false,
	false,
	false,
	false,
	0.5,
	0.35,
}

local nestHealthMultAndFoodDivisor = {
	false,
	false,
	false,
	false,
	1.8,
	2,
}

function api.GetMaxCharges(name)
	local maxCharges = (ItemDefs.defs[name].maxCharges or 1)
	if self.levelData.maxItemMod then
		maxCharges = math.floor(1 + maxCharges * (self.levelData.maxItemMod[name] or 1) * moddedMaxChargesDifficultyMod[self.world.GetDifficulty()])
	end
	local generalMod = generalMaxChargesDifficultyMod[self.world.GetDifficulty()]
	if generalMod then
		maxCharges = math.floor(1 + (maxCharges - 1) * generalMod)
	end
	return maxCharges
end

function api.GetRechargeTimeMod(name)
	local recharge = (LevelHandler.GetLevelData().tweaks.itemRechargeMult or 1) * difficultyRechargeMap[self.world.GetDifficulty()]
	if self.levelData.itemRechargeMod then
		recharge = recharge * (self.levelData.itemRechargeMod[name] or 1)
	end
	return recharge
end

function api.GetNestHealthMult()
	return (nestHealthMultAndFoodDivisor[self.world.GetDifficulty()] or 1) * (self.levelData.tweaks.nestHealthMult or 1)
end

function api.GetPoisonHealthMult()
	return (nestHealthMultAndFoodDivisor[self.world.GetDifficulty()] or 1) * (self.levelData.tweaks.poisonHealthMult or 1)
end

function api.GetFoodHealthMult()
	return (1 / (nestHealthMultAndFoodDivisor[self.world.GetDifficulty()] or 1)) * (self.levelData.tweaks.foodHealthMult or 1)
end

function api.GetItems()
	if self.world.GetCosmos().GetAllItemsMode() then
		return ItemDefs.itemList
	end
	return self.levelData.items
end

function api.BlockHealthChanges()
	return self.world.GetGameOver() or self.sandboxMode
end

function api.GetSandboxMode()
	return self.sandboxMode
end

function api.ToggleSandboxMode()
	self.sandboxMode = not self.sandboxMode
	self.world.GetCosmos().SaveSandboxMode(self.sandboxMode)
end


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
	local nestCount = AntHandler.CountImportantNests()
	local foodCount = AntHandler.CountImportantFood()
	if foodCount < self.levelData.mustRetainAtLeastThisMuchFood and not LevelHandler.GetEditMode() then
		if not self.world.GetGameOver() then
			ItemHandler.ReplaceActiveItem()
		end
		self.world.SetGameOver(false)
	end
	if nestCount <= 0 then
		if not self.world.GetGameOver() and not LevelHandler.GetEditMode() then
			ItemHandler.ReplaceActiveItem()
		end
		self.world.SetGameOver(true)
	end
end

function api.DrawInterface()
	local windowX, windowY = love.window.getMode()
end

function api.Initialize(world, levelData)
	self = {
		world = world,
		levelData = levelData,
		sandboxMode = world.GetCosmos().GetSandboxMode()
	}
end

return api
