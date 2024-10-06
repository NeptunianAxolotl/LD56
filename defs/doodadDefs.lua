
local doodads = util.LoadDefDirectory("defs/doodads")

for name, def in pairs(doodads) do
	def.name = name
end
local data = {
	defs = doodads,
}

return data
