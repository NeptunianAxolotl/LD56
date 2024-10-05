
local globals = {
	BACK_COL = {130/255, 162/255, 58/255},
	PANEL_COL = {0.53, 0.53, 0.55},
	
	MASTER_VOLUME = 0.75,
	MUSIC_VOLUME = 0.02,
	DEFAULT_MUSIC_DURATION = 174.69,
	CROSSFADE_TIME = 0,
	
	BLOCK_CACHE_GRID_SIZE = 3,
	BLOCK_RADIUS = {
		ant = 8,
		placement = 0,
	},
	
	ZOOM_OUT = 1,
	CAMERA_SPEED = 2,
	PHYSICS_SCALE = 300,
	LINE_SPACING = 36,
	INC_OFFSET = -15,
	SCENT_GRID_SIZE = 10,
	
	AIRHORN_RADIUS = 95,
	ACCELERATE_RADIUS = 110,
	INIT_LEVEL = "test_level",
	ITEM_COOLDOWN = 2,
	
	GRAVITY_MULT = 900,
	SPEED_LIMIT = 1800,
	TURN_MULT = 175,
	
	MOUSE_SCROLL_MULT = 0,
	KEYBOARD_SCROLL_MULT = 1.4,
	EDIT_GRID = 10,
	
	MOUSE_EDGE = 8,
	MOUSE_SCROLL = 1200,
	CAMERA_SPEED = 800,
	CAMERA_BOUND = 1600,
	
	SAVE_ORDER = {"humanName", "nextLevel", "prevLevel", "description", "width", "height", "nests", "food", "blocks"},
	SAVE_INLINE = {},
}

return globals