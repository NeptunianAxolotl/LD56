
local nests = util.LoadDefDirectory("defs/nests")

for name, def in pairs(nests) do
	def.name = name
end
local data = {
	defs = nests,
}

return data
