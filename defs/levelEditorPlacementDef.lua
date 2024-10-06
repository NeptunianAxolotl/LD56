
local deletionKey = "q"
local rotationKey = "z"
local otherRotateKey = "x"

local blocks = {
	w = "wall_hor",
	e = "wall_vert",
	s = "couch",
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

local doodads = {
	a = "void",
	c = "wall",
	v = "wall_edge",
	b = "wall_edge_flip",
	n = "wall_edge_inner",
	m = "wall_edge_inner_flip",
	d = "door",
}

local rotateable = {
	wall = true,
	wall_edge = true,
	wall_edge_flip = true,
	couch = true,
	door = true,
	wall_edge_inner = true,
	wall_edge_inner_flip = true
}

local data = {
	deletionKey = deletionKey,
	rotationKey = rotationKey,
	otherRotateKey = otherRotateKey,
	blocks = blocks,
	spawners = spawners,
	nests = nests,
	food = food,
	rotateable = rotateable,
	doodads = doodads,
}

return data
