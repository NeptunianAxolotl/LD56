local data = {
	humanName = "Bee",
	nextLevel = "level2",
	description = "Bees.",
	gameWon = "The ants have been successfully removed.",
	gameLost = "The ants ate all your food, you'll have to try again.",
	mustRetainAtLeastThisMuchFood = 0,
	lifetimeMultiplier = 1,
	width = 1800,
	height = 1050,
	items = {
		"renovate",
		"scent",
	},
	spawners = {
		{
			"many_bees",
			{
				380,
				260,
			},
		},
	},
	nests = {
	},
	food = {
		{
			"basic_food",
			{
				1040,
				520,
			},
		},
		{
			"basic_poison",
			{
				520,
				480,
			},
		},
	},
	blocks = {
	},
	doodads = {
	},
}

return data
