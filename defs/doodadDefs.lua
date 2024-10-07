
local doodads = util.LoadDefDirectory("defs/doodads")
local newDoodads = {}

for name, def in pairs(doodads) do
	if def.wantRotations then
		def.wantRotations = nil
		for i = 0, 270, 90 do
			local rotName = name .. "_" .. i
			local newDef = util.CopyTable(def)
			newDef.name = rotName
			if newDef.image then
				newDef.rotation = i * math.pi / 180
			else
				if i == 90 or i == 270 then
					newDef.width, newDef.height = newDef.height, newDef.width
				end
			end
			newDoodads[rotName] = newDef
		end
	else
		def.name = name
		newDoodads[name] = def
	end
end

local data = {
	defs = newDoodads,
}

return data
