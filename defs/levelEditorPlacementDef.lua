
local deletionKey = "q"

local blocks = {
	w = "wall",
	e = "wall_90",
	s = "couch",
	d = "couch_90",
	r = "rug",
}

local spawners = {
	y = "single_spider",
}

local nests = {
	g = "basic_nest",
}

local food = {
	h = "basic_food",
	j = "basic_poison",
}

local data = {
	deletionKey = deletionKey,
	blocks = blocks,
	spawners = spawners,
	nests = nests,
	food = food,
}

return data
