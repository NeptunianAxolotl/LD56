
local spawners = util.LoadDefDirectory("defs/spawners")

for name, def in pairs(spawners) do
	def.name = name
end
local data = {
	defs = spawners,
}

return data
