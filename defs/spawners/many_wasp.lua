
local data = {
	beeFrequency = 0.2,

	init = function (self)
		AntHandler.SpawnCreature("wasp", self.pos)
		self.beeTimer = 0
	end,
	update = function (self, dt)
		self.beeTimer = self.beeTimer + dt
		if self.beeTimer > 1/self.def.beeFrequency then
			AntHandler.SpawnCreature("wasp", self.pos)
			self.beeTimer = self.beeTimer - 1/self.def.beeFrequency
		end
	end,
}

return data
