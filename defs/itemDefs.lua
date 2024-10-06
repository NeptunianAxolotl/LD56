
local items = util.LoadDefDirectory("defs/items")
local itemList = {}

for name, def in pairs(items) do
	def.name = name
	itemList[#itemList + 1] = name
end
local data = {
	defs = items,
	itemList = itemList,
}

return data
