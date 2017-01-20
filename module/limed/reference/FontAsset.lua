local hori = {
	center = function(pos,screen)
		wrap = wrap or 0
		return Vector2:new(pos.x-screen/2,pos.y)
	end,
	right = function(pos,screen)
		wrap = wrap or 0
		return Vector2:new(pos.x-screen,pos.y)
	end
}

local alignment = {
	topleft = function(pos)
		return pos,0,"left"
	end,
	middleleft = function(pos)
		return pos,-0.5,"left"
	end,
	bottomleft = function(pos)
		return pos,-1,"left"
	end,
	topcenter = function(...)
		return hori.center(...),0,"center"
	end,
	middlecenter = function(...)
		return hori.center(...),-0.5,"center"
	end,
	bottomcenter = function(...)
		return hori.center(...),-1,"center"
	end,
	topright = function(...)
		return hori.right(...),0,"right"
	end,
	middleright = function(...)
		return hori.right(...),-0.5,"right"
	end,
	bottomright = function(...)
		return hori.right(...),-1,"right"
	end
}

local FontAsset = Instance:class("FontAsset",4)({
	font = nil,
	text = "",
	align = "topleft",
	color = Color:new(),
	wrap = nil,
	draw = function(self,x,y,angle,sx,sy)
		local screen = love.graphics.getDimensions()
		local font = self.font
		local pos,direction,align = alignment[self.align](
			Vector2:new(x,y),
			screen
		)
		local height = font:getHeight()
		love.graphics.setColor(self.color:components())

		if self.wrap then
			local _,text = font:getWrap(self.text,self.wrap)
			direction = #text*direction
			for i,v in pairs(text) do
				love.graphics.printf(v,pos.x,pos.y+direction*height,screen,align,angle,sx)
				direction = direction+1
			end
		else love.graphics.printf(self.text,pos.x,pos.y+height*direction,screen,align,angle,sy)
		end
	end
})