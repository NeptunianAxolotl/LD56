local data = {
	humanName = "Redecorating",
	width = 1400,
	height = 950,
	description = "Poison solves any ant infestation, but someone foolishly put it behind the couch.\n - Use the Hammer to free a path.\n - Use the scent tool to guide the ants.\nClick a tool to select it, then click in the room.",
	gameWon = "The ants have been successfully removed.",
	gameLost = "The ants ate all your food, you'll have to try again.",
	mustRetainAtLeastThisMuchFood = 0,
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
	},
	nests = {
	},
	food = {
	},
	blocks = {
		{
			"wall_big",
			{
				140,
				280,
			},
		},
		{
			"wall_big",
			{
				460,
				0,
			},
		},
		{
			"wall_big",
			{
				760,
				0,
			},
		},
		{
			"wall_big",
			{
				1060,
				0,
			},
		},
		{
			"wall_big",
			{
				1260,
				280,
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
				1300,
				0,
			},
		},
		{
			"wall_big",
			{
				40,
				600,
			},
		},
		{
			"wall_big",
			{
				1360,
				600,
			},
		},
		{
			"wall_big",
			{
				140,
				0,
			},
		},
		{
			"wall_big",
			{
				1360,
				880,
			},
		},
		{
			"wall_big",
			{
				40,
				880,
			},
		},
		{
			"wall_big",
			{
				180,
				1000,
			},
		},
		{
			"wall_big",
			{
				460,
				1000,
			},
		},
		{
			"wall_big",
			{
				760,
				1000,
			},
		},
		{
			"wall_big",
			{
				1060,
				1000,
			},
		},
	},
	doodads = {
		{
			"door_closed_180",
			{
				700,
				140,
			},
		},
		{
			"window_closed_180",
			{
				980,
				140,
			},
		},
		{
			"window_closed_180",
			{
				420,
				140,
			},
		},
		{
			"wall_inner_180",
			{
				280,
				140,
			},
		},
		{
			"wall_inner_270",
			{
				1120,
				140,
			},
		},
		{
			"door_closed_90",
			{
				180,
				640,
			},
		},
		{
			"door_closed_270",
			{
				1220,
				620,
			},
		},
	},
}

return data
