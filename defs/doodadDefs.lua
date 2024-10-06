
local doodads = util.LoadDefDirectory("defs/doodads")
local newDoodads = {}

for name, def in pairs(doodads) do
	if def.wantRotations then
		def.wantRotations = nil
		for i = 0, 270, 90 do
			local rotName = name .. "_" .. i
			local newDef = util.CopyTable(def)
			newDef.name = rotName
			newDef.rotation = i * math.pi / 180
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
