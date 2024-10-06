
local blocks = util.LoadDefDirectory("defs/blocks")

for name, def in pairs(blocks) do
	if def.wantRotations then
		def.wantRotations = nil
		blocks[name] = nil
		for i = 0, 270, 90 do
			local rotName = name .. "_" .. i
			local newDef = util.CopyTable(def)
			newDef.name = rotName
			newDef.rotation = i * math.pi / 180
			if i == 90 or i == 270 then
				newDef.width, newDef.height = newDef.height, newDef.width
			end
			blocks[rotName] = newDef
		end
	else
		def.name = name
	end
end

local data = {
	defs = blocks,
}

return data
