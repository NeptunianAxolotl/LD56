
local data = {
	speed = 75,
	turnCheckLength = 20,
	turnCheckAngle = 0.6,
	
	pathingType = "flying",
	airhornMult = 2,
	drawLayer = 320,
	
	arriveDist = 30,
	
	mopRadius = 70,
	mopStrength = 4,

	flipTable = {-1, 1},
	init = function (self)
		self.SetHomePosition(self.pos)
		self.enterTimer = 0
		local levelData = LevelHandler.GetLevelData()
		self.enterGoal = {levelData.width / 2, levelData.height / 2}
	end,
	
	update = function (self, dt)
		ScentHandler.AddScent("explore", self.pos, self.def.mopRadius, -dt*self.def.mopStrength)
		ScentHandler.AddScent("food", self.pos, self.def.mopRadius, -dt*self.def.mopStrength)

		self.wingtimer = (self.wingtimer or 0) + dt * ((self.lastSpeed or 65)/65)
		if self.wingtimer > 0.15 then
			self.wingtimer = 0
		end
	end,
	
	draw = function (self, drawQueue)

		local butterflyImage = "butterfly_a"
		if (self.wingtimer or 0) > 0.075 then
			butterflyImage = "butterfly_b"
		end

		local butterfly_scale = 1.1
		if (self.direction + math.pi/2)%(math.pi*2) > math.pi then
			Resources.DrawImage(butterflyImage, self.pos[1], self.pos[2], 0, 1, butterfly_scale)
		else
			Resources.DrawImage(butterflyImage, self.pos[1], self.pos[2], 0, 1, {-butterfly_scale, butterfly_scale})
		end
	end,
	
	GetSpeedAndDirection = function (self, dt)
		local directionChange = false
		if math.random() < 0.1 then
			directionChange = math.random()*26 - 13
		else
			directionChange = math.random()*3 - 1.5
		end
		directionChange = directionChange * 5

		local speed = self.def.speed * self.speedMult * (self.accelMult or 1)
		if self.airhornEffect then
			speed = speed * (1 + self.airhornEffect*4 * self.def.airhornMult)
			directionChange = directionChange * (0.4 * (2 - self.airhornEffect))
			self.pickupFoodTimer = false
		end
		return speed, directionChange
	end
}

return data
