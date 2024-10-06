
local deletionKey = "q"
local rotationKey = "z"
local otherRotateKey = "x"

local blocks = {
	w = "wall_hor",
	d = "placement_blocker",
	s = "wall_big",
	e = "wall_vert",
	y = "couch",
	r = "rug",
	t = "houseplant",
	f = "vase",
}

local spawners = {
	kp7 = "single_spider",
}

local nests = {
	kp8 = "basic_nest",
}

local food = {
	kp1 = "basic_food",
	kp2 = "basic_poison",
}

local doodads = {
	a = "void",
	c = "wall",
	v = "door",
}

local rotateable = {
	wall = true,
	wall_edge = true,
	wall_edge_flip = true,
	couch = true,
	rug = true,
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
