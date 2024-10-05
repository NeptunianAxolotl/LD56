
local names = util.GetDefDirList("resources/images/blocks", "png")
local data = {}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/blocks/" .. names[i] .. ".png",
		form = "image",
		xScale = 0.5,
		yScale = 0.5,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
