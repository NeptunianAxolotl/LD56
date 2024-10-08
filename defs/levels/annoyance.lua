local data = {
	humanName = "Annoyance",
	width = 1350,
	height = 800,
	description = "What is worse than a spider? Two spiders. This room is far too small for the number of bugs crammed in here.\n\nThe butterflies are a pain too, but nothing that can't be solved by a good honking.",
	gameWon = "Amazingly, there is now one fewer type of bug infesting this room.",
	gameLost = "Chaos wins this time.\n\nPress Ctrl+R to try again.",
	mustRetainAtLeastThisMuchFood = 1,
	tweaks = {
		foodHealthMult = 1,
		initialItemsProp = 1,
		itemRechargeMult = 1,
		lifetimeMultiplier = 1,
		nestHealthMult = 1,
		nestSpawnRate = 1,
	},
	items = {
		"renovate",
		"airhorn",
		"accelerate",
		"pickup",
		"mop",
	},
	itemRechargeMod = {
		airhorn = 1.2,
	},
	spawners = {
		{
			"single_forever_butterfly",
			{
				800,
				580,
			},
		},
		{
			"single_spider",
			{
				160,
				140,
			},
		},
		{
			"single_forever_butterfly",
			{
				700,
				180,
			},
		},
		{
			"single_spider",
			{
				980,
				540,
			},
		},
	},
	nests = {
		{
			"basic_nest",
			{
				180,
				640,
			},
		},
	},
	food = {
		{
			"basic_poison",
			{
				1180,
				180,
			},
		},
		{
			"basic_food",
			{
				800,
				360,
			},
		},
	},
	blocks = {
		{
			"wall_big",
			{
				-120,
				660,
			},
		},
		{
			"wall_big",
			{
				160,
				920,
			},
		},
		{
			"wall_big",
			{
				480,
				920,
			},
		},
		{
			"wall_big",
			{
				800,
				920,
			},
		},
		{
			"wall_big",
			{
				1120,
				920,
			},
		},
		{
			"wall_big",
			{
				1440,
				920,
			},
		},
		{
			"wall_big",
			{
				1480,
				600,
			},
		},
		{
			"wall_big",
			{
				1480,
				280,
			},
		},
		{
			"wall_big",
			{
				1480,
				-40,
			},
		},
		{
			"wall_big",
			{
				1160,
				-120,
			},
		},
		{
			"wall_big",
			{
				840,
				-120,
			},
		},
		{
			"wall_big",
			{
				520,
				-120,
			},
		},
		{
			"wall_big",
			{
				-120,
				420,
			},
		},
		{
			"wall_big",
			{
				-120,
				140,
			},
		},
		{
			"wall_big",
			{
				200,
				-120,
			},
		},
		{
			"wall_big",
			{
				1280,
				760,
			},
		},
		{
			"wall_hor",
			{
				980,
				280,
			},
		},
		{
			"wall_hor",
			{
				980,
				320,
			},
		},
		{
			"wall_hor",
			{
				980,
				360,
			},
		},
		{
			"wall_hor",
			{
				340,
				260,
			},
		},
		{
			"wall_hor",
			{
				500,
				260,
			},
		},
		{
			"wall_hor",
			{
				500,
				300,
			},
		},
		{
			"wall_hor",
			{
				340,
				300,
			},
		},
		{
			"rug_180",
			{
				560,
				640,
			},
		},
		{
			"houseplant",
			{
				760,
				600,
			},
		},
		{
			"houseplant",
			{
				300,
				180,
			},
		},
		{
			"couch_0",
			{
				560,
				480,
			},
		},
	},
	doodads = {
		{
			"wall_0",
			{
				100,
				780,
			},
		},
		{
			"wall_0",
			{
				260,
				780,
			},
		},
		{
			"wall_0",
			{
				420,
				780,
			},
		},
		{
			"wall_0",
			{
				580,
				780,
			},
		},
		{
			"wall_0",
			{
				740,
				780,
			},
		},
		{
			"wall_0",
			{
				900,
				780,
			},
		},
		{
			"wall_0",
			{
				1060,
				780,
			},
		},
		{
			"wall_270",
			{
				1140,
				700,
			},
		},
		{
			"wall_0",
			{
				1220,
				620,
			},
		},
		{
			"wall_0",
			{
				1260,
				620,
			},
		},
		{
			"wall_270",
			{
				1340,
				540,
			},
		},
		{
			"wall_270",
			{
				1340,
				400,
			},
		},
		{
			"wall_270",
			{
				1340,
				260,
			},
		},
		{
			"wall_270",
			{
				1340,
				120,
			},
		},
		{
			"wall_180",
			{
				1260,
				20,
			},
		},
		{
			"wall_180",
			{
				1120,
				20,
			},
		},
		{
			"wall_180",
			{
				960,
				20,
			},
		},
		{
			"wall_180",
			{
				820,
				20,
			},
		},
		{
			"wall_180",
			{
				660,
				20,
			},
		},
		{
			"wall_180",
			{
				500,
				20,
			},
		},
		{
			"wall_180",
			{
				340,
				20,
			},
		},
		{
			"wall_180",
			{
				200,
				20,
			},
		},
		{
			"wall_180",
			{
				100,
				20,
			},
		},
		{
			"wall_90",
			{
				20,
				100,
			},
		},
		{
			"wall_90",
			{
				20,
				240,
			},
		},
		{
			"wall_90",
			{
				20,
				380,
			},
		},
		{
			"wall_90",
			{
				20,
				520,
			},
		},
		{
			"wall_90",
			{
				20,
				660,
			},
		},
		{
			"wall_90",
			{
				20,
				700,
			},
		},
		{
			"wall_inner_0",
			{
				1340,
				620,
			},
		},
		{
			"wall_inner_270",
			{
				1340,
				20,
			},
		},
		{
			"wall_inner_180",
			{
				20,
				20,
			},
		},
		{
			"wall_inner_90",
			{
				20,
				780,
			},
		},
		{
			"wall_outer_270",
			{
				1140,
				620,
			},
		},
		{
			"wall_inner_0",
			{
				1140,
				780,
			},
		},
		{
			"wall_small_0",
			{
				520,
				260,
			},
		},
		{
			"wall_small_0",
			{
				480,
				260,
			},
		},
		{
			"wall_small_0",
			{
				440,
				260,
			},
		},
		{
			"wall_small_0",
			{
				380,
				260,
			},
		},
		{
			"wall_outer_90",
			{
				560,
				300,
			},
		},
		{
			"wall_outer_0",
			{
				560,
				260,
			},
		},
		{
			"wall_outer_270",
			{
				280,
				260,
			},
		},
		{
			"wall_outer_180",
			{
				280,
				300,
			},
		},
		{
			"wall_small_180",
			{
				320,
				300,
			},
		},
		{
			"wall_small_180",
			{
				380,
				300,
			},
		},
		{
			"wall_small_180",
			{
				440,
				300,
			},
		},
		{
			"wall_small_180",
			{
				500,
				300,
			},
		},
		{
			"wall_small_180",
			{
				520,
				300,
			},
		},
		{
			"wall_small_0",
			{
				320,
				260,
			},
		},
		{
			"wall_outer_0",
			{
				1040,
				280,
			},
		},
		{
			"wall_outer_90",
			{
				1040,
				360,
			},
		},
		{
			"wall_outer_180",
			{
				920,
				360,
			},
		},
		{
			"wall_outer_270",
			{
				920,
				280,
			},
		},
		{
			"wall_small_270",
			{
				920,
				320,
			},
		},
		{
			"wall_small_180",
			{
				960,
				360,
			},
		},
		{
			"wall_small_180",
			{
				1000,
				360,
			},
		},
		{
			"wall_small_0",
			{
				960,
				280,
			},
		},
		{
			"wall_small_0",
			{
				1000,
				280,
			},
		},
		{
			"wall_small_90",
			{
				1040,
				320,
			},
		},
		{
			"small_void",
			{
				960,
				320,
			},
		},
		{
			"small_void",
			{
				1000,
				320,
			},
		},
		{
			"void",
			{
				1360,
				840,
			},
		},
		{
			"door_closed_0",
			{
				960,
				780,
			},
		},
		{
			"window_closed_180",
			{
				280,
				20,
			},
		},
		{
			"window_closed_180",
			{
				1020,
				20,
			},
		},
		{
			"door_closed_90",
			{
				20,
				420,
			},
		},
		{
			"window_closed_270",
			{
				1340,
				340,
			},
		},
	},
}

return data
