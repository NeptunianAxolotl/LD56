
local deletionKey = "q"
local rotationKey = "x"
local otherRotateKey = "z"

local blocks = {
	w = "wall_hor",
	e = "wall_vert",
	
	s = "placement_blocker",
	r = "rug",
	t = "houseplant",
	y = "couch",
	
	g = "wall_filler",
	h = "wall_big",
	
	j = "vase",
	k = "fan",
	
	i = "flying_door_hor",
	o = "flying_door_vert",
}

local spawners = {
	kp7 = "single_spider",
	["kp/"] = "many_bees",
	["kp*"] = "single_bee",
	kp8 = "many_wasp",
	kp9 = "single_wasp",
	kp5 = "many_butterfly",
	kp6 = "single_forever_butterfly",
}

local nests = {
	kp4 = "basic_nest",
}

local food = {
	kp1 = "basic_food",
	kp2 = "basic_poison",
	kp3 = "limited_poison",
	kp0 = "cake_food",
	["kp."] = "strawberry_food",
}

local doodads = {
	a = "void",
	[";"] = "void_long",
	l = "small_void",
	d = "wall_inner",
	f = "wall_outer",
	c = "wall",
	v = "wall_small",
	b = "door_closed",
	n = "door_open",
	m = "window_closed",
	[","] = "window_open",
	["."] = "window_garden",
}

local rotateable = {
	wall = true,
	wall_small = true,
	wall_inner = true,
	wall_outer = true,
	door_closed = true,
	door_open = true,
	window_closed = true,
	window_open = true,
	window_garden = true,
	void_long = true,
	
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
