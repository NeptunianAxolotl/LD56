
local globals = {
	BACK_COL = {141/255, 75/255, 14/255},
	TILE_COL = {124/255, 149/255, 61/255},
	BACK_COL_EDITOR = {1.2*10/255, 1.2*84/255, 1.2*156/255},
	
	HOVER_HIGHLIGHT = {240/255, 179/255, 86/255},
	BUTTON_BORDER = {99/255, 68/255, 36/255},
	
	PUSH_BUTTON_BORDER = {124/255, 149/255, 61/255},
	BUTTON_HIGHLIGHT = {198/255, 206/255, 105/255},
	BUTTON_BACK = {175/255, 185/255, 92/255},
	
	HINT_BACK = {198/255, 206/255, 105/255},
	HINT_OUTLINE = {74/255, 91/255, 32/255},
	
	PANEL_COL = {197/255, 136/255, 71/255},
	PANEL_DISABLE_COL = {206/255,176/255,107/255},
	PANEL_FLASH_COL = {143/255, 151/255, 191/25},
	PANEL_HIGHLIGHT_COL = {252/255, 252/255, 201/255},
	OUTLINE_COL = {142/255, 115/255, 94/255},
	OUTLINE_DISABLE_COL = {143/255, 151/255, 191/255},
	OUTLINE_FLASH_COL = {45/255,48/255,61/255},
	OUTLINE_HIGHLIGHT_COL = {142/255, 115/255, 94/255},
	AFFINITY_COLOR = {0, 0, 0},
	
	TEXT_DISABLE_COL    = {143/255, 151/255, 191/255},
	TEXT_FLASH_COL      = {0.73, 0.73, 0.75},
	TEXT_HIGHLIGHT_COL  = {9/255, 11/255, 17/255},
	TEXT_COL            = {9/255, 11/255, 17/255},
	FLOATING_TEXT_COL   = {0.95,0.95,0.9},
	
	HEALTH_BAR_COL = {13/255, 180/255, 80/255},
	HEALTH_BAR_BACK = {200/255, 11/255, 00/255},
	
	
	TEST_WON = false,
	TEST_LOST = false,
	TEST_LEVEL_NAME = "test_level",
	
	WIN_FADE_TIME = 2,
	BUTTON_FLASH_PERIOD = 0.6,
	PLANK_SCALE = 0.52,
	MOUSE_ITEM_SCALE = 0.7,
	SHOP_IMAGE_SCALE = 0.9,
	
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
	INIT_LEVEL = "level_bee",
	
	SHOP_WIDTH = 400,
	VIEW_WIDTH = 1920,
	VIEW_HEIGHT = 1080,
	
	SCENT_MIN_ADD = 0.45,
	EXPLORE_DECAY = 0.92,
	FOOD_DECAY = 0.88,
	
	GRAVITY_MULT = 900,
	SPEED_LIMIT = 1800,
	TURN_MULT = 175,
	
	MOUSE_SCROLL_MULT = 0,
	KEYBOARD_SCROLL_MULT = 1.4,
	EDIT_GRID = 20,
	
	MOUSE_EDGE = 8,
	MOUSE_SCROLL = 1200,
	CAMERA_SPEED = 800,
	CAMERA_BOUND = 1600,
	
	SAVE_ORDER = {
		"humanName", "nextLevel", "prevLevel",  "width", "height",
		"description",  "gameWon", "gameLost",
		"mustRetainAtLeastThisMuchFood", "nestHealthMult", "foodHealthMult", "initialItemsProp",
		"itemRechargeMult", "lifetimeMultiplier",
		"hints", "items", "spawners", "nests", "food", "blocks", "doodads"
	},
	SAVE_INLINE = {"pos", "size"},
}

return globals