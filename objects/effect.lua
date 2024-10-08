
local Resources = require("resourceHandler")
local Font = require("include/font")

local DRAW_DEBUG = false

local function NewEffect(self, def)
	-- pos
	self.drawLayer = def.drawLayer or 0
	local maxLife = (def.duration == "inherit" and def.image and Resources.GetAnimationDuration(def.image)) or def.duration
	self.life = maxLife
	self.animTime = 0
	self.direction = def.rotation or (def.randomDirection and math.random()*2*math.pi) or 0
	
	self.pos = (def.spawnOffset and util.Add(self.pos, def.spawnOffset)) or self.pos
	
	local function GetAlpha()
		if not def.alphaScale then
			return 1
		end
		if def.alphaBuffer then
			if self.life / maxLife > 1 - def.alphaBuffer then
				return 1
			end
			return (self.life / maxLife) / (1 - def.alphaBuffer)
		end
		return self.life/maxLife
	end
	
	function self.Update(dt)
		self.animTime = self.animTime + dt
		self.life = self.life - dt
		if self.life <= 0 then
			return true
		end
		
		if self.velocity then
			self.pos = util.Add(self.pos, util.Mult(dt*60, self.velocity))
		end
	end
	
	function self.Draw(drawQueue)
		drawQueue:push({y=self.drawLayer + self.pos[1]*0.001 + self.pos[2]*0.001; f=function()
			if def.fontSize and self.text then
				local col = def.color
				Font.SetSize(def.fontSize)
				love.graphics.setColor((col and col[1]) or 1, (col and col[2]) or 1, (col and col[3]) or 1, GetAlpha())
				love.graphics.printf(self.text, self.pos[1] - def.textWidth/2, self.pos[2] - def.textHeight, def.textWidth, "center")
				love.graphics.setColor(1, 1, 1, 1)
			elseif self.actualImageOverride or def.actual_image then
				print("def.actual_image", self.drawLayer)
				Resources.DrawImage(self.actualImageOverride or def.actual_image, self.pos[1], self.pos[2], self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - 0.5*self.life/maxLife)) or 1),
				def.color)
			else
				Resources.DrawAnimation(def.image, self.pos[1], self.pos[2], self.animTime, self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - 0.5*self.life/maxLife)) or 1),
				def.color)
			end
		end})
		if DRAW_DEBUG then
			love.graphics.circle('line',self.pos[1], self.pos[2], def.radius)
		end
	end
	
	function self.DrawInterface()
		if self.actualImageOverride or def.actual_image then
			Resources.DrawImage(self.actualImageOverride or def.actual_image, self.pos[1], self.pos[2], self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - 0.5*self.life/maxLife)) or 1),
				def.color)
		else
			Resources.DrawAnimation(def.image, self.pos[1], self.pos[2], self.animTime, self.direction, GetAlpha(),
					(self.scale or 1)*((def.lifeScale and (1 - 0.5*self.life/maxLife)) or 1),
				def.color)
		end
		if DRAW_DEBUG then
			love.graphics.circle('line',self.pos[1], self.pos[2], 100)
		end
	end
	
	return self
end

return NewEffect
