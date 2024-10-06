
local blocks = util.LoadDefDirectory("defs/blocks")
local newBlocks = {}

for name, def in pairs(blocks) do
	print("loaded block", name)
	if def.wantRotations then
		def.wantRotations = nil
		for i = 0, 270, 90 do
			local rotName = name .. "_" .. i
			local newDef = util.CopyTable(def)
			newDef.name = rotName
			newDef.rotation = i * math.pi / 180
			if i == 90 or i == 270 then
				newDef.width, newDef.height = newDef.height, newDef.width
			end
			newBlocks[rotName] = newDef
		end
	else
		def.name = name
		newBlocks[name] = def
	end
end

local data = {
	defs = newBlocks,
}

return data
