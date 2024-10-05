
local creatures = util.LoadDefDirectory("defs/creatures")

for name, def in pairs(creatures) do
	def.name = name
end
local data = {
	defs = creatures,
}

return data
