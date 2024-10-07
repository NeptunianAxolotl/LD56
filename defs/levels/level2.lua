local data = {
	humanName = "Redecorating",
	prevLevel = "level1",
	nextLevel = "level_bee",
	width = 1350,
	height = 880,
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
		nestSpawnRate = 0.35,
		spiderActivityMult = 2,
	},
	items = {
		"renovate",
		"airhorn",
	},
	spawners = {
		{
			"single_spider",
			{
				820,
				360,
			},
		},
	},
	nests = {
		{
			"basic_nest",
			{
				380,
				560,
			},
		},
	},
	food = {
		{
			"basic_poison",
			{
				1080,
				320,
			},
		},
	},
	blocks = {
		{
			"wall_big",
			{
				420,
				220,
			},
		},
		{
			"vase",
			{
				640,
				220,
			},
		},
		{
			"vase",
			{
				780,
				640,
			},
		},
		{
			"wall_big",
			{
				1220,
				640,
			},
		},
		{
			"wall_big",
			{
				1340,
				500,
			},
		},
		{
			"wall_big",
			{
				60,
				720,
			},
		},
		{
			"wall_big",
			{
				60,
				440,
			},
		},
		{
			"wall_big",
			{
				1340,
				200,
			},
		},
		{
			"wall_big",
			{
				240,
				220,
			},
		},
		{
			"wall_big",
			{
				140,
				140,
			},
		},
		{
			"wall_big",
			{
				300,
				860,
			},
		},
		{
			"wall_big",
			{
				600,
				860,
			},
		},
		{
			"wall_big",
			{
				800,
				860,
			},
		},
		{
			"wall_big",
			{
				1000,
				640,
			},
		},
		{
			"wall_big",
			{
				620,
				0,
			},
		},
		{
			"wall_big",
			{
				1100,
				0,
			},
		},
		{
			"wall_big",
			{
				860,
				0,
			},
		},
	},
	doodads = {
		{
			"door_closed_270",
			{
				1200,
				320,
			},
		},
		{
			"door_closed_90",
			{
				200,
				540,
			},
		},
	},
}

return data
