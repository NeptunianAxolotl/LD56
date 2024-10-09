
local items = util.LoadDefDirectory("defs/items")

for name, def in pairs(items) do
	def.name = name
end

local itemList = {
	"renovate",
	"airhorn",
	"accelerate",
	"pickup",
	"scent",
	"mop",
	"place_food",
}

local data = {
	defs = items,
	itemList = itemList,
}

return data
