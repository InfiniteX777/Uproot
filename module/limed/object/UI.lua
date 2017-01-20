local UI = Instance:class("UI",3)({
	elements = {},
	add = function(self,v)
		if v:is("UI") then
			self.elements[v] = true
			self.elementAdded:fire(v)
		end
	end,
	rem = function(self,v)
		if self.elements[v] then
			self.elements[v] = nil
			self.elementRemoved:fire(v)
		end
	end,
	destroy = function(self)
		for k,v in pairs(self.elements) do
			if v then
				k:destroy()
			else self.elements[k] = nil
				self.elementRemoved:fire(v)
			end
		end
	end,
	update = function(self,dt)
		for k,v in pairs(self.elements) do
			if v then
				k:update(dt)
			else self.elements[k] = nil
				self.elementRemoved:fire(v)
			end
		end
	end,
	draw = function(self,...)
		for k,v in pairs(self.elements) do
			if v then
				k:draw(...)
			else self.elements[k] = nil
				self.elementRemoved:fire(v)
			end
		end
	end,
	elementAdded = Instance.event,
	elementRemoved = Instance.event
})

local Frame = UI:class("Frame",3)({
	position = {
		offset = Vector2:new(),
		scale = Vector2:new()
	},
	rotation = 0,
	size = {
		offset = Vector2:new(),
		scale = Vector2:new()
	},
	fillColor = Color:new(255,255,255),
	outlineColor = Color:new(),
	image = nil,
	hover = false,
	new = function(self)
		local InputService = Instance:service("InputService")
		self.mouseMovedHook = InputService.mouseMoved:connect(function(x,y,...)
			local a,b = self:rect()
			if (a-b).mag > 0 then
				if x >= a.x and x <= b.x and y >= a.y and y <= b.y then
					if not self.hover then
						self.hover = true
						self.mouseEntered:fire(x,y,...)
					else self.mouseMoved:fire(x,y,...)
					end
				elseif self.hover then
					self.hover = false
					self.mouseLeave:fire(x,y,...)
				end
			end
		end)
		self.mouseDownHook = InputService.mouseDown:connect(function(...)
			if self.hover then
				self.mouseDown:fire(...)
			end
		end)
		self.mouseUpHook = InputService.mouseUp:connect(function(...)
			if self.hover then
				self.mouseUp:fire(...)
			end
		end)
		self.mouseWheelHook = InputService.mouseWheel:connect(function(...)
			if self.hover then
				self.mouseWheel:fire(...)
			end
		end)
	end,
	rect = function(self)
		local screen = Vector2:new(love.graphics.getDimensions())
		local position = self.position.offset+self.position.scale*screen
		local size = self.size.offset+self.size.scale*screen
		return position:rect(size+position)
	end,
	destroy = function(self)
		for _,v in pairs({"Moved","Down","Up","Wheel"}) do
			if self["mouse"..v.."Hook"] then
				self["mouse"..v.."Hook"]:disconnect()
			end
		end
	end,
	draw = function(self,x,y,angle,sx,sy)
		local a,b = self:rect()
		b = b-a
		a = a+Vector2:new(x,y)
		b = b+Vector2:new(x,y)
		love.graphics.rotate(angle+self.rotation)
		love.graphics.setColor(self.fillColor:components())
		love.graphics.rectangle("fill",a.x,a.y,b.x,b.y)
		love.graphics.setColor(self.outlineColor:components())
		love.graphics.rectangle("line",a.x,a.y,b.x,b.y)
		if self.image then
			local width,height = self.image.width,self.image.height
			width = b.x/width
			height = b.y/height
			self.image:draw(a.x,a.y,0,width*sx,height*sy)
		end
		love.graphics.origin()
	end,
	mouseEntered = Instance.event,
	mouseMoved = Instance.event,
	mouseLeave = Instance.event,
	mouseDown = Instance.event,
	mouseUp = Instance.event,
	mouseWheel = Instance.event
})

local alignment = {
	topleft = function(pos,size)
		return pos
	end,
	middleleft = function(pos,size)
		return Vector2:new(pos.x,pos.y+size.y/2)
	end,
	bottomleft = function(pos,size)
		return Vector2:new(pos.x,pos.y+size.y)
	end,
	topcenter = function(pos,size)
		return Vector2:new(pos.x+size.x/2,pos.y)
	end,
	middlecenter = function(pos,size)
		return pos+size/2
	end,
	bottomcenter = function(pos,size)
		return Vector2:new(pos.x+size.x/2,pos.y+size.y)
	end,
	topright = function(pos,size)
		return Vector2:new(pos.x+size.x,pos.y)
	end,
	middleright = function(pos,size)
		return Vector2:new(pos.x+size.x,pos.y+size.y/2)
	end,
	bottomright = function(pos,size)
		return pos+size
	end
}

local Label = Frame:class("Label",3)({
	text = "",
	textAlign = "middlecenter",
	textColor = Color:new(),
	textWrap = false,
	font = nil,
	new = function(self)
		self.font = Instance:service("ContentService"):getFont()
	end,
	draw = function(self,x,y,angle,...)
		local a,b = self:rect()
		self.font.text = self.text
		self.font.color = self.textColor ~= self.font.color and self.textColor:clone() or self.font.color
		self.font.align = self.textAlign
		self.font.wrap = self.textWrap and (b-a).x
		local pos = alignment[self.textAlign](a,b-a)
		love.graphics.rotate(angle+self.rotation)
		self.font:draw(pos.x,pos.y,0,...)
		love.graphics.origin()
	end
})