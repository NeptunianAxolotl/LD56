local data = {
	humanName = "Long Butterfly Hall",
	width = 1350,
	height = 900,
	description = "Ah butterflies! They wipe away the scent of ant (they have very powerful wings). But even more interesting is the hallway of this house, it seems to go on forever.\n\nThis cheese is important, see that it is not harmed.",
	gameWon = "The ants are gone, only butterflies (and cheese) remains.",
	gameLost = "The cheese is gone. We mourn its passing.\n\nPress Ctrl+R to try again.",
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
		"pickup",
		"mop",
	},
	spawners = {
		{
			"many_butterfly",
			{
				580,
				140,
			},
		},
		{
			"many_butterfly",
			{
				880,
				120,
			},
		},
	},
	nests = {
		{
			"basic_nest",
			{
				320,
				440,
			},
		},
	},
	food = {
		{
			"basic_food",
			{
				620,
				440,
			},
		},
		{
			"basic_poison",
			{
				820,
				440,
			},
		},
	},
	blocks = {
		{
			"wall_big",
			{
				-80,
				120,
			},
		},
		{
			"wall_big",
			{
				240,
				120,
			},
		},
		{
			"wall_big",
			{
				1520,
				760,
			},
		},
		{
			"houseplant",
			{
				960,
				700,
			},
		},
		{
			"wall_big",
			{
				1200,
				120,
			},
		},
		{
			"wall_big",
			{
				1520,
				120,
			},
		},
		{
			"wall_big",
			{
				-80,
				760,
			},
		},
		{
			"wall_big",
			{
				240,
				760,
			},
		},
		{
			"wall_big",
			{
				880,
				940,
			},
		},
		{
			"wall_big",
			{
				560,
				940,
			},
		},
		{
			"wall_big",
			{
				1200,
				760,
			},
		},
		{
			"flying_door_hor",
			{
				480,
				260,
			},
		},
		{
			"flying_door_hor",
			{
				640,
				260,
			},
		},
		{
			"flying_door_hor",
			{
				800,
				260,
			},
		},
		{
			"flying_door_hor",
			{
				960,
				260,
			},
		},
		{
			"houseplant",
			{
				480,
				700,
			},
		},
		{
			"placement_blocker",
			{
				480,
				160,
			},
		},
		{
			"placement_blocker",
			{
				640,
				160,
			},
		},
		{
			"placement_blocker",
			{
				800,
				160,
			},
		},
		{
			"placement_blocker",
			{
				960,
				160,
			},
		},
		{
			"placement_blocker",
			{
				960,
				40,
			},
		},
		{
			"placement_blocker",
			{
				640,
				40,
			},
		},
		{
			"placement_blocker",
			{
				480,
				40,
			},
		},
		{
			"placement_blocker",
			{
				800,
				40,
			},
		},
		{
			"wall_hor",
			{
				480,
				-20,
			},
		},
		{
			"wall_hor",
			{
				640,
				-20,
			},
		},
		{
			"wall_hor",
			{
				800,
				-20,
			},
		},
		{
			"wall_hor",
			{
				960,
				-20,
			},
		},
		{
			"wall_big",
			{
				1460,
				700,
			},
		},
		{
			"wall_big",
			{
				1460,
				180,
			},
		},
		{
			"wall_big",
			{
				-100,
				180,
			},
		},
		{
			"wall_big",
			{
				-100,
				700,
			},
		},
	},
	doodads = {
		{
			"door_open_90",
			{
				40,
				440,
			},
		},
		{
			"door_open_270",
			{
				1320,
				440,
			},
		},
		{
			"window_garden_180",
			{
				880,
				260,
			},
		},
		{
			"window_open_180",
			{
				880,
				260,
			},
		},
		{
			"window_open_180",
			{
				560,
				260,
			},
		},
		{
			"window_garden_180",
			{
				560,
				260,
			},
		},
		{
			"void",
			{
				-180,
				440,
			},
		},
		{
			"void",
			{
				1540,
				440,
			},
		},
		{
			"wall_0",
			{
				120,
				620,
			},
		},
		{
			"wall_0",
			{
				280,
				620,
			},
		},
		{
			"wall_0",
			{
				500,
				800,
			},
		},
		{
			"wall_0",
			{
				660,
				800,
			},
		},
		{
			"wall_0",
			{
				820,
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
				960,
				800,
			},
		},
		{
			"wall_0",
			{
				980,
				800,
			},
		},
		{
			"wall_270",
			{
				1060,
				720,
			},
		},
		{
			"wall_0",
			{
				1140,
				620,
			},
		},
		{
			"wall_0",
			{
				1240,
				620,
			},
		},
		{
			"wall_180",
			{
				1240,
				260,
			},
		},
		{
			"wall_180",
			{
				1120,
				260,
			},
		},
		{
			"wall_180",
			{
				320,
				260,
			},
		},
		{
			"wall_180",
			{
				160,
				260,
			},
		},
		{
			"wall_180",
			{
				120,
				260,
			},
		},
		{
			"wall_small_90",
			{
				380,
				660,
			},
		},
		{
			"wall_small_90",
			{
				380,
				720,
			},
		},
		{
			"wall_small_90",
			{
				380,
				760,
			},
		},
		{
			"wall_inner_180",
			{
				40,
				260,
			},
		},
		{
			"wall_inner_90",
			{
				40,
				620,
			},
		},
		{
			"wall_inner_90",
			{
				380,
				800,
			},
		},
		{
			"wall_inner_0",
			{
				1060,
				800,
			},
		},
		{
			"wall_inner_0",
			{
				1320,
				620,
			},
		},
		{
			"wall_inner_270",
			{
				1320,
				260,
			},
		},
		{
			"wall_outer_0",
			{
				380,
				620,
			},
		},
		{
			"wall_outer_270",
			{
				1060,
				620,
			},
		},
		{
			"void",
			{
				160,
				840,
			},
		},
		{
			"void",
			{
				560,
				1020,
			},
		},
		{
			"void",
			{
				900,
				1020,
			},
		},
		{
			"void",
			{
				1280,
				840,
			},
		},
		{
			"void",
			{
				1160,
				40,
			},
		},
		{
			"door_closed_0",
			{
				720,
				800,
			},
		},
		{
			"void",
			{
				380,
				40,
			},
		},
		{
			"void",
			{
				60,
				40,
			},
		},
		{
			"void",
			{
				760,
				40,
			},
		},
	},
}

return data
