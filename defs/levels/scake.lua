local data = {
	humanName = "Redecorating",
	width = 1350,
	height = 900,
	description = "Poison solves any ant infestation, but someone foolishly put it behind the couch.\n - Use the Hammer to free a path.\n - Use the scent tool to guide the ants.\nClick a tool to select it, then click in the room.",
	gameWon = "The ants have been successfully removed.",
	gameLost = "The ants ate all your food, you'll have to try again.",
	mustRetainAtLeastThisMuchFood = 4,
	tweaks = {
		foodHealthMult = 1,
		initialItemsProp = 1,
		itemRechargeMult = 1,
		lifetimeMultiplier = 1,
		nestHealthMult = 0.5,
		nestSpawnRate = 1,
	},
	itemRechargeMod = {
		scent = 10,
	},
	items = {
		"renovate",
		"airhorn",
		"scent",
	},
	spawners = {
		{
			"single_spider",
			{
				1120,
				340,
			},
		},
	},
	nests = {
		{
			"basic_nest",
			{
				240,
				740,
			},
		},
	},
	food = {
		{
			"basic_poison",
			{
				1120,
				160,
			},
		},
		{
			"cake_food",
			{
				1240,
				780,
			},
		},
		{
			"basic_food",
			{
				740,
				140,
			},
		},
		{
			"basic_food",
			{
				600,
				760,
			},
		},
		{
			"basic_food",
			{
				140,
				140,
			},
		},
	},
	blocks = {
		{
			"wall_big",
			{
				140,
				1020,
			},
		},
		{
			"wall_big",
			{
				460,
				1020,
			},
		},
		{
			"wall_big",
			{
				780,
				1020,
			},
		},
		{
			"wall_big",
			{
				1100,
				1020,
			},
		},
		{
			"wall_big",
			{
				1420,
				1020,
			},
		},
		{
			"wall_big",
			{
				1480,
				700,
			},
		},
		{
			"wall_big",
			{
				1480,
				380,
			},
		},
		{
			"wall_big",
			{
				1480,
				60,
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
				200,
				-120,
			},
		},
		{
			"wall_big",
			{
				-120,
				-120,
			},
		},
		{
			"wall_big",
			{
				-120,
				200,
			},
		},
		{
			"wall_big",
			{
				-120,
				520,
			},
		},
		{
			"wall_big",
			{
				-120,
				840,
			},
		},
		{
			"wall_filler",
			{
				860,
				380,
			},
		},
		{
			"wall_filler",
			{
				860,
				420,
			},
		},
		{
			"wall_filler",
			{
				860,
				460,
			},
		},
		{
			"wall_filler",
			{
				860,
				500,
			},
		},
		{
			"wall_filler",
			{
				860,
				540,
			},
		},
		{
			"wall_filler",
			{
				860,
				580,
			},
		},
		{
			"wall_filler",
			{
				900,
				580,
			},
		},
		{
			"wall_filler",
			{
				900,
				540,
			},
		},
		{
			"wall_filler",
			{
				900,
				500,
			},
		},
		{
			"wall_filler",
			{
				900,
				460,
			},
		},
		{
			"wall_filler",
			{
				900,
				420,
			},
		},
		{
			"wall_filler",
			{
				900,
				380,
			},
		},
		{
			"wall_filler",
			{
				480,
				320,
			},
		},
		{
			"wall_filler",
			{
				440,
				320,
			},
		},
		{
			"wall_filler",
			{
				900,
				300,
			},
		},
		{
			"wall_filler",
			{
				860,
				340,
			},
		},
		{
			"wall_filler",
			{
				900,
				340,
			},
		},
		{
			"wall_filler",
			{
				860,
				300,
			},
		},
		{
			"wall_filler",
			{
				860,
				260,
			},
		},
		{
			"wall_filler",
			{
				860,
				220,
			},
		},
		{
			"wall_filler",
			{
				860,
				180,
			},
		},
		{
			"wall_filler",
			{
				860,
				140,
			},
		},
		{
			"wall_filler",
			{
				860,
				100,
			},
		},
		{
			"wall_filler",
			{
				860,
				60,
			},
		},
		{
			"wall_filler",
			{
				900,
				60,
			},
		},
		{
			"wall_filler",
			{
				900,
				100,
			},
		},
		{
			"wall_filler",
			{
				900,
				140,
			},
		},
		{
			"wall_filler",
			{
				900,
				180,
			},
		},
		{
			"wall_filler",
			{
				900,
				220,
			},
		},
		{
			"wall_filler",
			{
				900,
				260,
			},
		},
		{
			"wall_filler",
			{
				440,
				360,
			},
		},
		{
			"wall_filler",
			{
				440,
				400,
			},
		},
		{
			"wall_filler",
			{
				440,
				440,
			},
		},
		{
			"wall_filler",
			{
				440,
				480,
			},
		},
		{
			"wall_filler",
			{
				440,
				520,
			},
		},
		{
			"wall_filler",
			{
				440,
				560,
			},
		},
		{
			"wall_filler",
			{
				440,
				600,
			},
		},
		{
			"wall_filler",
			{
				440,
				640,
			},
		},
		{
			"wall_filler",
			{
				440,
				680,
			},
		},
		{
			"wall_filler",
			{
				440,
				720,
			},
		},
		{
			"wall_filler",
			{
				440,
				760,
			},
		},
		{
			"wall_filler",
			{
				440,
				800,
			},
		},
		{
			"wall_filler",
			{
				440,
				840,
			},
		},
		{
			"wall_filler",
			{
				480,
				840,
			},
		},
		{
			"wall_filler",
			{
				480,
				800,
			},
		},
		{
			"wall_filler",
			{
				480,
				760,
			},
		},
		{
			"wall_filler",
			{
				480,
				720,
			},
		},
		{
			"wall_filler",
			{
				480,
				680,
			},
		},
		{
			"wall_filler",
			{
				480,
				640,
			},
		},
		{
			"wall_filler",
			{
				480,
				600,
			},
		},
		{
			"wall_filler",
			{
				480,
				560,
			},
		},
		{
			"wall_filler",
			{
				480,
				520,
			},
		},
		{
			"wall_filler",
			{
				480,
				480,
			},
		},
		{
			"wall_filler",
			{
				480,
				440,
			},
		},
		{
			"wall_filler",
			{
				480,
				400,
			},
		},
		{
			"wall_filler",
			{
				480,
				360,
			},
		},
		{
			"vase",
			{
				880,
				660,
			},
		},
		{
			"vase",
			{
				460,
				240,
			},
		},
	},
	doodads = {
		{
			"wall_270",
			{
				860,
				500,
			},
		},
		{
			"wall_90",
			{
				900,
				120,
			},
		},
		{
			"wall_inner_180",
			{
				900,
				20,
			},
		},
		{
			"wall_inner_270",
			{
				860,
				20,
			},
		},
		{
			"wall_outer_90",
			{
				900,
				580,
			},
		},
		{
			"wall_90",
			{
				900,
				280,
			},
		},
		{
			"wall_90",
			{
				900,
				500,
			},
		},
		{
			"wall_270",
			{
				860,
				440,
			},
		},
		{
			"wall_small_0",
			{
				520,
				880,
			},
		},
		{
			"wall_inner_0",
			{
				1340,
				880,
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
			"wall_small_0",
			{
				400,
				880,
			},
		},
		{
			"wall_small_0",
			{
				60,
				880,
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
			"wall_inner_90",
			{
				20,
				880,
			},
		},
		{
			"wall_270",
			{
				860,
				280,
			},
		},
		{
			"wall_270",
			{
				860,
				120,
			},
		},
		{
			"wall_small_180",
			{
				1300,
				20,
			},
		},
		{
			"wall_inner_90",
			{
				480,
				880,
			},
		},
		{
			"wall_90",
			{
				900,
				440,
			},
		},
		{
			"door_closed_0",
			{
				240,
				880,
			},
		},
		{
			"door_closed_180",
			{
				1120,
				20,
			},
		},
		{
			"wall_90",
			{
				20,
				800,
			},
		},
		{
			"wall_90",
			{
				20,
				640,
			},
		},
		{
			"wall_90",
			{
				20,
				500,
			},
		},
		{
			"wall_90",
			{
				20,
				340,
			},
		},
		{
			"wall_90",
			{
				20,
				180,
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
			"wall_270",
			{
				1340,
				100,
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
				420,
			},
		},
		{
			"wall_270",
			{
				1340,
				580,
			},
		},
		{
			"wall_270",
			{
				1340,
				740,
			},
		},
		{
			"wall_270",
			{
				1340,
				800,
			},
		},
		{
			"wall_0",
			{
				1260,
				880,
			},
		},
		{
			"wall_0",
			{
				1100,
				880,
			},
		},
		{
			"wall_0",
			{
				940,
				880,
			},
		},
		{
			"wall_0",
			{
				780,
				880,
			},
		},
		{
			"wall_0",
			{
				620,
				880,
			},
		},
		{
			"wall_180",
			{
				780,
				20,
			},
		},
		{
			"wall_180",
			{
				620,
				20,
			},
		},
		{
			"wall_180",
			{
				460,
				20,
			},
		},
		{
			"wall_180",
			{
				300,
				20,
			},
		},
		{
			"wall_180",
			{
				140,
				20,
			},
		},
		{
			"wall_small_180",
			{
				60,
				20,
			},
		},
		{
			"wall_small_180",
			{
				940,
				20,
			},
		},
		{
			"wall_270",
			{
				440,
				800,
			},
		},
		{
			"wall_270",
			{
				440,
				640,
			},
		},
		{
			"wall_270",
			{
				440,
				480,
			},
		},
		{
			"wall_270",
			{
				440,
				400,
			},
		},
		{
			"wall_90",
			{
				480,
				800,
			},
		},
		{
			"wall_90",
			{
				480,
				640,
			},
		},
		{
			"wall_90",
			{
				480,
				480,
			},
		},
		{
			"wall_90",
			{
				480,
				400,
			},
		},
		{
			"wall_outer_270",
			{
				440,
				320,
			},
		},
		{
			"wall_outer_0",
			{
				480,
				320,
			},
		},
		{
			"wall_inner_0",
			{
				440,
				880,
			},
		},
		{
			"wall_outer_180",
			{
				860,
				580,
			},
		},
	},
}

return data
