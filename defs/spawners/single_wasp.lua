
local data = {
	init = function (self)
		local wasp = AntHandler.SpawnCreature("wasp", self.pos)
			if wasp then
			local levelData = LevelHandler.GetLevelData()
			for i = 1, #levelData.spawners do
				local spawner = levelData.spawners[i]
				if spawner[1] == "many_wasp" then
					wasp.SetHomePosition(spawner[2])
				end
			end
		end
	end,
	update = function (self, dt)
	end,
}

return data
