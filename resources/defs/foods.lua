
local names = util.GetDefDirList("resources/images/food", "png")
local data = {}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/food/" .. names[i] .. ".png",
		form = "image",
		xScale = 1,
		yScale = 1,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
