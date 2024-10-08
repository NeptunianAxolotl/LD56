local data = {
	humanName = "Freedom",
	width = 2480,
	height = 1650,
	description = "We escaped the house, but there are ants out here too and we left our poison back inside. For that matter, are we truly outside?\n\nToggle Sandbox Mode in the menu below for an invulnerable cake and nest.",
	gameWon = "The ants are gone, from both outside and in. There are no more ants, anywhere. That button below? Useless.\n\nThat said, you could go back to the start (hold Ctrl+P) and turn on Hard Mode in the Menu.\n\nThanks for playing!",
	gameLost = "Perhaps it is time to go back inside.\n\nPress Ctrl+R to try again.",
	worldWrap = true,
	mustRetainAtLeastThisMuchFood = 1,
	tweaks = {
		foodHealthMult = 1,
		initialItemsProp = 1,
		itemRechargeMult = 1,
		lifetimeMultiplier = 1,
		nestHealthMult = 1,
		nestSpawnRate = 1,
	},
	maxItemMod = {
		scent = 0.8,
		nop = 0.8,
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
		{
			"single_forever_butterfly",
			{
				1000,
				580,
			},
		},
		{
			"single_spider",
			{
				2040,
				540,
			},
		},
	},
	nests = {
		{
			"basic_nest",
			{
				460,
				520,
			},
		},
	},
	food = {
		{
			"basic_poison",
			{
				1760,
				800,
			},
		},
		{
			"cake_food",
			{
				840,
				1140,
			},
		},
	},
	blocks = {
		{
			"wall_vert",
			{
				2200,
				560,
			},
		},
		{
			"wall_vert",
			{
				2160,
				500,
			},
		},
		{
			"wall_vert",
			{
				2200,
				440,
			},
		},
		{
			"wall_vert",
			{
				2160,
				440,
			},
		},
		{
			"wall_hor",
			{
				2000,
				1160,
			},
		},
		{
			"wall_hor",
			{
				2080,
				1200,
			},
		},
		{
			"wall_vert",
			{
				1420,
				980,
			},
		},
		{
			"vase",
			{
				1280,
				460,
			},
		},
		{
			"wall_hor",
			{
				1440,
				1200,
			},
		},
		{
			"wall_hor",
			{
				1520,
				1160,
			},
		},
		{
			"wall_hor",
			{
				1600,
				1200,
			},
		},
		{
			"wall_vert",
			{
				1420,
				520,
			},
		},
		{
			"wall_hor",
			{
				1580,
				420,
			},
		},
		{
			"wall_vert",
			{
				1380,
				520,
			},
		},
		{
			"vase",
			{
				380,
				1160,
			},
		},
		{
			"wall_vert",
			{
				1420,
				620,
			},
		},
		{
			"wall_vert",
			{
				1380,
				620,
			},
		},
		{
			"wall_hor",
			{
				1440,
				380,
			},
		},
		{
			"couch_90",
			{
				1280,
				800,
			},
		},
		{
			"fan_180",
			{
				2040,
				820,
			},
		},
		{
			"wall_hor",
			{
				1580,
				380,
			},
		},
		{
			"wall_hor",
			{
				1440,
				420,
			},
		},
		{
			"wall_vert",
			{
				1380,
				1100,
			},
		},
		{
			"wall_vert",
			{
				1420,
				1100,
			},
		},
		{
			"wall_hor",
			{
				1680,
				1160,
			},
		},
		{
			"wall_hor",
			{
				1760,
				1200,
			},
		},
		{
			"wall_hor",
			{
				1840,
				1160,
			},
		},
		{
			"wall_hor",
			{
				1920,
				1200,
			},
		},
		{
			"wall_vert",
			{
				2200,
				780,
			},
		},
		{
			"wall_vert",
			{
				2160,
				780,
			},
		},
		{
			"wall_vert",
			{
				2200,
				660,
			},
		},
		{
			"wall_vert",
			{
				2160,
				640,
			},
		},
		{
			"wall_hor",
			{
				2060,
				380,
			},
		},
		{
			"wall_hor",
			{
				2060,
				420,
			},
		},
		{
			"wall_hor",
			{
				1900,
				420,
			},
		},
		{
			"wall_hor",
			{
				1900,
				380,
			},
		},
		{
			"wall_hor",
			{
				1740,
				380,
			},
		},
		{
			"wall_hor",
			{
				1740,
				420,
			},
		},
		{
			"wall_vert",
			{
				1380,
				980,
			},
		},
		{
			"rug_90",
			{
				320,
				540,
			},
		},
		{
			"rug_0",
			{
				560,
				380,
			},
		},
		{
			"couch_0",
			{
				1800,
				520,
			},
		},
		{
			"rug_0",
			{
				720,
				1200,
			},
		},
		{
			"rug_270",
			{
				800,
				1000,
			},
		},
		{
			"rug_270",
			{
				940,
				1220,
			},
		},
		{
			"wall_vert",
			{
				2160,
				1140,
			},
		},
		{
			"wall_vert",
			{
				2200,
				1140,
			},
		},
		{
			"wall_hor",
			{
				2100,
				1160,
			},
		},
		{
			"houseplant",
			{
				2180,
				1000,
			},
		},
		{
			"wall_vert",
			{
				2160,
				860,
			},
		},
		{
			"wall_vert",
			{
				2200,
				860,
			},
		},
		{
			"houseplant",
			{
				1540,
				1040,
			},
		},
	},
	doodads = {
		{
			"door_open_90",
			{
				1420,
				800,
			},
		},
		{
			"door_open_270",
			{
				1380,
				800,
			},
		},
		{
			"wall_90",
			{
				1420,
				1020,
			},
		},
		{
			"wall_90",
			{
				1420,
				1080,
			},
		},
		{
			"wall_0",
			{
				1520,
				1160,
			},
		},
		{
			"wall_0",
			{
				1660,
				1160,
			},
		},
		{
			"wall_0",
			{
				1760,
				380,
			},
		},
		{
			"wall_0",
			{
				1980,
				1160,
			},
		},
		{
			"wall_0",
			{
				2060,
				1160,
			},
		},
		{
			"wall_outer_180",
			{
				1380,
				1200,
			},
		},
		{
			"wall_outer_270",
			{
				1380,
				380,
			},
		},
		{
			"wall_180",
			{
				1980,
				1200,
			},
		},
		{
			"wall_0",
			{
				1620,
				380,
			},
		},
		{
			"wall_180",
			{
				1660,
				1200,
			},
		},
		{
			"wall_180",
			{
				1500,
				1200,
			},
		},
		{
			"wall_180",
			{
				1480,
				1200,
			},
		},
		{
			"wall_270",
			{
				1380,
				1100,
			},
		},
		{
			"wall_270",
			{
				1380,
				1020,
			},
		},
		{
			"wall_270",
			{
				1380,
				580,
			},
		},
		{
			"wall_270",
			{
				1380,
				460,
			},
		},
		{
			"wall_0",
			{
				1460,
				380,
			},
		},
		{
			"wall_0",
			{
				1820,
				1160,
			},
		},
		{
			"wall_180",
			{
				1820,
				1200,
			},
		},
		{
			"wall_180",
			{
				1500,
				420,
			},
		},
		{
			"wall_90",
			{
				1420,
				580,
			},
		},
		{
			"wall_90",
			{
				1420,
				500,
			},
		},
		{
			"wall_180",
			{
				1640,
				420,
			},
		},
		{
			"wall_180",
			{
				1800,
				420,
			},
		},
		{
			"wall_180",
			{
				1960,
				420,
			},
		},
		{
			"wall_180",
			{
				2060,
				420,
			},
		},
		{
			"wall_0",
			{
				1920,
				380,
			},
		},
		{
			"wall_0",
			{
				2040,
				380,
			},
		},
		{
			"wall_outer_0",
			{
				2200,
				380,
			},
		},
		{
			"wall_90",
			{
				2200,
				480,
			},
		},
		{
			"wall_90",
			{
				2200,
				640,
			},
		},
		{
			"wall_90",
			{
				2200,
				800,
			},
		},
		{
			"wall_small_0",
			{
				2140,
				380,
			},
		},
		{
			"wall_inner_270",
			{
				2160,
				420,
			},
		},
		{
			"wall_270",
			{
				2160,
				780,
			},
		},
		{
			"wall_270",
			{
				2160,
				620,
			},
		},
		{
			"wall_270",
			{
				2160,
				520,
			},
		},
		{
			"wall_small_0",
			{
				2160,
				380,
			},
		},
		{
			"wall_inner_180",
			{
				1420,
				420,
			},
		},
		{
			"wall_inner_90",
			{
				1420,
				1160,
			},
		},
		{
			"wall_90",
			{
				2200,
				840,
			},
		},
		{
			"wall_270",
			{
				2160,
				840,
			},
		},
		{
			"wall_inner_0",
			{
				2160,
				1160,
			},
		},
		{
			"wall_small_270",
			{
				2160,
				1120,
			},
		},
		{
			"wall_small_90",
			{
				2200,
				1120,
			},
		},
		{
			"wall_small_90",
			{
				2200,
				1160,
			},
		},
		{
			"wall_180",
			{
				2100,
				1200,
			},
		},
		{
			"wall_outer_90",
			{
				2200,
				920,
			},
		},
		{
			"wall_outer_90",
			{
				2200,
				1200,
			},
		},
		{
			"wall_outer_0",
			{
				2200,
				1080,
			},
		},
		{
			"wall_outer_270",
			{
				2160,
				1080,
			},
		},
		{
			"wall_outer_180",
			{
				2160,
				920,
			},
		},
	},
	zoom = 1.4,
}

return data
