
local names = util.GetDefDirList("resources/images/shop_items", "png")
local data = {}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/shop_items/" .. names[i] .. ".png",
		form = "image",
		xScale = 0.7,
		yScale = 0.7,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
