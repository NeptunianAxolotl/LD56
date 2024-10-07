
local data = {
	init = function (self)
		local bee = AntHandler.SpawnCreature("bee", self.pos)
			if bee then
			local levelData = LevelHandler.GetLevelData()
			for i = 1, #levelData.spawners do
				local spawner = levelData.spawners[i]
				if spawner[1] == "many_bees" then
					bee.SetHomePosition(spawner[2])
				end
			end
		end
	end,
	update = function (self, dt)
	end,
}

return data
