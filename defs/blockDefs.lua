
local blocks = util.LoadDefDirectory("defs/blocks")

for name, def in pairs(blocks) do
	def.name = name
end
local data = {
	defs = blocks,
}

return data
