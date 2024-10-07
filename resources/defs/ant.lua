
local names = util.GetDefDirList("resources/images/ants", "png")
local data = {}

for i = 1, #names do
	data[#data + 1] = {
		name = names[i],
		file = "resources/images/ants/" .. names[i] .. ".png",
		form = "image",
		xScale = 0.3,
		yScale = 0.3,
		xOffset = 0.5,
		yOffset = 0.5,
	}
end

return data
