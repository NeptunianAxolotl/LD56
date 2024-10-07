local data = {
	humanName = "Redecorating",
	prevLevel = "level4",
	nextLevel = "level_bee",
	width = 1350,
	height = 800,
	description = "Poison solves any ant infestation, but someone foolishly put it behind the couch.\n - Use the Hammer to free a path.\n - Use the scent tool to guide the ants.\nClick a tool to select it, then click in the room.",
	gameWon = "The ants have been successfully removed.",
	gameLost = "The ants ate all your food, you'll have to try again.",
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
		"scent",
		"mop",
		"place_food",
	},
	spawners = {
		{
			"single_spider",
			{
				680,
				420,
			},
		},
	},
	nests = {
		{
			"basic_nest",
			{
				1180,
				160,
			},
		},
	},
	food = {
		{
			"basic_poison",
			{
				140,
				640,
			},
		},
		{
			"basic_food",
			{
				940,
				680,
			},
		},
	},
	blocks = {
		{
			"wall_big",
			{
				1180,
				440,
			},
		},
		{
			"wall_big",
			{
				1180,
				720,
			},
		},
		{
			"wall_big",
			{
				960,
				940,
			},
		},
		{
			"wall_big",
			{
				1180,
				-140,
			},
		},
		{
			"houseplant",
			{
				680,
				540,
			},
		},
		{
			"wall_big",
			{
				-140,
				640,
			},
		},
		{
			"wall_big",
			{
				160,
				360,
			},
		},
		{
			"wall_big",
			{
				860,
				-140,
			},
		},
		{
			"wall_big",
			{
				540,
				-140,
			},
		},
		{
			"wall_big",
			{
				220,
				-140,
			},
		},
		{
			"wall_filler",
			{
				760,
				580,
			},
		},
		{
			"wall_filler",
			{
				600,
				540,
			},
		},
		{
			"wall_filler",
			{
				800,
				300,
			},
		},
		{
			"wall_filler",
			{
				600,
				500,
			},
		},
		{
			"wall_filler",
			{
				800,
				580,
			},
		},
		{
			"wall_filler",
			{
				840,
				500,
			},
		},
		{
			"wall_filler",
			{
				760,
				540,
			},
		},
		{
			"wall_filler",
			{
				600,
				580,
			},
		},
		{
			"wall_filler",
			{
				840,
				540,
			},
		},
		{
			"wall_filler",
			{
				800,
				500,
			},
		},
		{
			"wall_filler",
			{
				760,
				500,
			},
		},
		{
			"wall_filler",
			{
				800,
				540,
			},
		},
		{
			"wall_filler",
			{
				840,
				580,
			},
		},
		{
			"wall_filler",
			{
				760,
				300,
			},
		},
		{
			"wall_filler",
			{
				760,
				540,
			},
		},
		{
			"wall_filler",
			{
				560,
				580,
			},
		},
		{
			"wall_filler",
			{
				560,
				540,
			},
		},
		{
			"wall_filler",
			{
				560,
				500,
			},
		},
		{
			"wall_filler",
			{
				520,
				500,
			},
		},
		{
			"wall_filler",
			{
				520,
				540,
			},
		},
		{
			"wall_filler",
			{
				520,
				580,
			},
		},
		{
			"wall_filler",
			{
				600,
				340,
			},
		},
		{
			"wall_filler",
			{
				560,
				340,
			},
		},
		{
			"wall_filler",
			{
				520,
				340,
			},
		},
		{
			"wall_filler",
			{
				520,
				300,
			},
		},
		{
			"wall_filler",
			{
				560,
				300,
			},
		},
		{
			"wall_filler",
			{
				600,
				300,
			},
		},
		{
			"wall_filler",
			{
				600,
				260,
			},
		},
		{
			"wall_filler",
			{
				560,
				260,
			},
		},
		{
			"wall_filler",
			{
				520,
				260,
			},
		},
		{
			"wall_filler",
			{
				760,
				340,
			},
		},
		{
			"wall_filler",
			{
				800,
				340,
			},
		},
		{
			"wall_filler",
			{
				840,
				340,
			},
		},
		{
			"wall_filler",
			{
				840,
				300,
			},
		},
		{
			"wall_filler",
			{
				840,
				260,
			},
		},
		{
			"wall_filler",
			{
				800,
				260,
			},
		},
		{
			"wall_filler",
			{
				760,
				260,
			},
		},
		{
			"wall_big",
			{
				160,
				80,
			},
		},
		{
			"houseplant",
			{
				680,
				300,
			},
		},
		{
			"wall_big",
			{
				80,
				940,
			},
		},
		{
			"wall_big",
			{
				380,
				940,
			},
		},
		{
			"wall_big",
			{
				700,
				940,
			},
		},
		{
			"wall_big",
			{
				1460,
				280,
			},
		},
		{
			"wall_big",
			{
				1460,
				80,
			},
		},
	},
	doodads = {
		{
			"wall_small_270",
			{
				520,
				300,
			},
		},
		{
			"wall_small_270",
			{
				520,
				540,
			},
		},
		{
			"small_void",
			{
				800,
				540,
			},
		},
		{
			"wall_small_270",
			{
				760,
				540,
			},
		},
		{
			"small_void",
			{
				560,
				540,
			},
		},
		{
			"wall_small_90",
			{
				840,
				540,
			},
		},
		{
			"wall_small_90",
			{
				600,
				540,
			},
		},
		{
			"wall_small_90",
			{
				600,
				300,
			},
		},
		{
			"wall_small_0",
			{
				560,
				260,
			},
		},
		{
			"small_void",
			{
				560,
				300,
			},
		},
		{
			"wall_small_0",
			{
				560,
				500,
			},
		},
		{
			"wall_small_0",
			{
				800,
				500,
			},
		},
		{
			"wall_small_180",
			{
				800,
				580,
			},
		},
		{
			"wall_small_180",
			{
				560,
				580,
			},
		},
		{
			"wall_small_180",
			{
				560,
				340,
			},
		},
		{
			"void",
			{
				80,
				140,
			},
		},
		{
			"wall_outer_180",
			{
				520,
				580,
			},
		},
		{
			"wall_outer_270",
			{
				520,
				260,
			},
		},
		{
			"wall_outer_270",
			{
				760,
				500,
			},
		},
		{
			"wall_outer_270",
			{
				520,
				500,
			},
		},
		{
			"wall_outer_0",
			{
				600,
				260,
			},
		},
		{
			"wall_outer_180",
			{
				520,
				340,
			},
		},
		{
			"wall_outer_0",
			{
				600,
				500,
			},
		},
		{
			"wall_outer_0",
			{
				840,
				500,
			},
		},
		{
			"wall_outer_90",
			{
				840,
				580,
			},
		},
		{
			"wall_outer_90",
			{
				600,
				580,
			},
		},
		{
			"wall_outer_90",
			{
				600,
				340,
			},
		},
		{
			"small_void",
			{
				800,
				300,
			},
		},
		{
			"wall_small_90",
			{
				840,
				300,
			},
		},
		{
			"wall_small_180",
			{
				800,
				340,
			},
		},
		{
			"wall_small_270",
			{
				760,
				300,
			},
		},
		{
			"wall_small_0",
			{
				800,
				260,
			},
		},
		{
			"wall_outer_0",
			{
				840,
				260,
			},
		},
		{
			"wall_outer_90",
			{
				840,
				340,
			},
		},
		{
			"wall_outer_180",
			{
				760,
				340,
			},
		},
		{
			"wall_outer_270",
			{
				760,
				260,
			},
		},
		{
			"door_closed_270",
			{
				1320,
				140,
			},
		},
		{
			"door_closed_90",
			{
				0,
				640,
			},
		},
		{
			"window_closed_180",
			{
				520,
				0,
			},
		},
		{
			"window_closed_180",
			{
				840,
				0,
			},
		},
		{
			"window_closed_90",
			{
				300,
				220,
			},
		},
		{
			"door_closed_0",
			{
				680,
				800,
			},
		},
		{
			"wall_0",
			{
				920,
				800,
			},
		},
		{
			"wall_0",
			{
				460,
				800,
			},
		},
		{
			"wall_0",
			{
				300,
				800,
			},
		},
		{
			"wall_0",
			{
				140,
				800,
			},
		},
		{
			"wall_180",
			{
				100,
				500,
			},
		},
		{
			"wall_180",
			{
				220,
				500,
			},
		},
		{
			"wall_270",
			{
				1040,
				680,
			},
		},
		{
			"wall_270",
			{
				1040,
				520,
			},
		},
		{
			"wall_0",
			{
				1180,
				300,
			},
		},
		{
			"wall_180",
			{
				1220,
				0,
			},
		},
		{
			"wall_180",
			{
				1060,
				0,
			},
		},
		{
			"wall_small_0",
			{
				40,
				800,
			},
		},
		{
			"wall_small_90",
			{
				300,
				400,
			},
		},
		{
			"wall_small_90",
			{
				300,
				460,
			},
		},
		{
			"wall_small_90",
			{
				300,
				40,
			},
		},
		{
			"wall_small_180",
			{
				340,
				0,
			},
		},
		{
			"wall_small_0",
			{
				1280,
				300,
			},
		},
		{
			"wall_small_0",
			{
				1080,
				300,
			},
		},
		{
			"wall_small_270",
			{
				1040,
				420,
			},
		},
		{
			"wall_small_270",
			{
				1040,
				360,
			},
		},
		{
			"wall_small_270",
			{
				1040,
				340,
			},
		},
		{
			"wall_small_0",
			{
				1000,
				800,
			},
		},
		{
			"wall_small_270",
			{
				1040,
				760,
			},
		},
		{
			"wall_inner_0",
			{
				1040,
				800,
			},
		},
		{
			"wall_inner_90",
			{
				0,
				800,
			},
		},
		{
			"wall_inner_180",
			{
				0,
				500,
			},
		},
		{
			"wall_inner_180",
			{
				300,
				0,
			},
		},
		{
			"wall_inner_0",
			{
				1320,
				300,
			},
		},
		{
			"wall_outer_270",
			{
				1040,
				300,
			},
		},
		{
			"wall_outer_90",
			{
				300,
				500,
			},
		},
		{
			"void",
			{
				1260,
				520,
			},
		},
		{
			"void",
			{
				1260,
				720,
			},
		},
		{
			"void",
			{
				80,
				280,
			},
		},
		{
			"wall_outer_180",
			{
				760,
				580,
			},
		},
	},
}

return data
