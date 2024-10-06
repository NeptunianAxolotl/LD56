
local doodads = util.LoadDefDirectory("defs/doodads")

for name, def in pairs(doodads) do
	if def.wantRotations then
		def.wantRotations = nil
		doodads[name] = nil
		for i = 0, 270, 90 do
			local rotName = name .. "_" .. i
			local newDef = util.CopyTable(def)
			newDef.name = rotName
			newDef.rotation = i * math.pi / 180
			doodads[rotName] = newDef
		end
	else
		def.name = name
	end
end

local data = {
	defs = doodads,
}

return data
