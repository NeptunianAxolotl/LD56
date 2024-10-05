
local food = util.LoadDefDirectory("defs/food")

for name, def in pairs(food) do
	def.name = name
end
local data = {
	defs = food,
}

return data
