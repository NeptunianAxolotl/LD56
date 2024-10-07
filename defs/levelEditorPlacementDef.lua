
local deletionKey = "q"
local rotationKey = "z"
local otherRotateKey = "x"

local blocks = {
	w = "wall_hor",
	e = "wall_vert",
	
	d = "placement_blocker",
	r = "rug",
	t = "houseplant",
	y = "couch",
	
	f = "wall_big",
	h = "vase",
	j = "fan",
	
	i = "flying_door_hor",
	o = "flying_door_vert",
}

local spawners = {
	kp7 = "single_spider",
	kp8 = "many_bees",
	kp9 = "many_butterfly",
}

local nests = {
	kp4 = "basic_nest",
}

local food = {
	kp1 = "basic_food",
	kp2 = "basic_poison",
}

local doodads = {
	a = "void",
	c = "wall",
	s = "wall_inner",
	d = "wall_outer",
	v = "door_closed",
	b = "door_open",
	n = "window_closed",
	m = "window_open",
	[","] = "window_garden",
}

local rotateable = {
	wall = true,
	wall_inner = true,
	wall_outer = true,
	door_closed = true,
	door_open = true,
	window_closed = true,
	window_open = true,
	window_garden = true,
	
	couch = true,
	rug = true,
	fan = true,
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
