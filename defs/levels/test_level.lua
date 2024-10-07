local data = {
	humanName = "test",
	nextLevel = "level1",
	description = "The owner of this house hired you to deal with their ant problem, but your apprentice put the poison inside rather than near the nest! Worse, you were explicitly told not to touch the decorative cake in the front yard. Use a combination of furniture rearrangement, airhorns, and drugs, to send the health of the nest to zero before the cake suffers the same fate. (Press the number keys and click buttons)",
	width = 2600,
	height = 1400,
	lifetimeMultiplier = 1,
	mustRetainAtLeastThisMuchFood = 0,
	nestHealthMult = 1,
	foodHealthMult = 1,
	initialItemsProp = 1,
	itemRechargeMult = 1,
	lifetimeMultiplier = 1,
	hints = {
		{
			pos = {1800, 200},
			size = {200, 100},
			text = "- Hello.",
		},
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
				900,
				400,
			},
		},
	},
	nests = {
		{
			"basic_nest",
			{
				400,
				400,
			},
		},
	},
	food = {
		{
			"basic_food",
			{
				900,
				900,
			},
		},
		{
			"basic_poison",
			{
				1750,
				650,
			},
		},
	},
	blocks = {
		{
			"wall_hor",
			{
				1430,
				250,
			},
		},
		{
			"wall_hor",
			{
				1630,
				250,
			},
		},
		{
			"wall_hor",
			{
				1830,
				250,
			},
		},
		{
			"wall_hor",
			{
				2030,
				250,
			},
		},
		{
			"wall_vert",
			{
				2150,
				330,
			},
		},
		{
			"wall_vert",
			{
				2150,
				530,
			},
		},
		{
			"rug_0",
			{
				520,
				260,
			},
		},
		{
			"wall_vert",
			{
				2150,
				730,
			},
		},
		{
			"wall_hor",
			{
				2070,
				1050,
			},
		},
		{
			"wall_hor",
			{
				1870,
				1050,
			},
		},
		{
			"wall_hor",
			{
				1670,
				1050,
			},
		},
		{
			"wall_hor",
			{
				1470,
				1050,
			},
		},
		{
			"wall_vert",
			{
				1350,
				970,
			},
		},
		{
			"wall_vert",
			{
				1350,
				370,
			},
		},
		{
			"rug_0",
			{
				1000,
				960,
			},
		},
		{
			"log",
			{
				2160,
				930,
			},
		},
		{
			"rug_0",
			{
				770,
				1030,
			},
		},
		{
			"rug_0",
			{
				880,
				820,
			},
		},
		{
			"log_90",
			{
				470,
				1030,
			},
		},
		{
			"rug_0",
			{
				260,
				490,
			},
		},
		{
			"rug_0",
			{
				310,
				300,
			},
		},
		{
			"rug_0",
			{
				450,
				480,
			},
		},
		{
			"wall_vert",
			{
				1350,
				850,
			},
		},
		{
			"log",
			{
				1350,
				600,
			},
		},
		{
			"wall_hor",
			{
				860,
				1260,
			},
		},
	},
	zoom = 1.4,
}

return data
