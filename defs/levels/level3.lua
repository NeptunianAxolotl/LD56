local data = {
	humanName = "Redecorating",
	nextLevel = "level_bee",
	prevLevel = "level2",
	width = 1350,
	height = 800,
	description = "Poison solves any ant infestation, but someone foolishly put it behind the couch.\n - Use the Hammer to free a path.\n - Use the scent tool to guide the ants.\nClick a tool to select it, then click in the room.",
	gameWon = "The ants have been successfully removed.",
	gameLost = "The ants ate all your food, you'll have to try again.",
	mustRetainAtLeastThisMuchFood = 0,
	tweaks = {
		nestHealthMult = 1,
		foodHealthMult = 1,
		initialItemsProp = 1,
		itemRechargeMult = 1,
		lifetimeMultiplier = 1,
		nestSpawnRate = 1,
	},
	items = {
		"renovate",
		"airhorn",
		"accelerate",
		"pickup",
		"scent",
		"mop",
		"place_food",
	},
	spawners = {
	},
	nests = {
	},
	food = {
	},
	blocks = {
	},
}

return data
