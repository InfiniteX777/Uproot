local Entity = Instance:class("Entity",3)({
	sprite = nil,
	hitbox = Vector2:new(),
	position = Vector2:new(),
	velocity = Vector2:new(),
	isGrounded = function(self,map)
		local r = Ray:new(position,Vector2:new(0,-1),self.hitbox.y/2)

		return r:hit(map)
	end,
	push = function(self,v)
		self.velocity = self.velocity+v
	end,
	update = function(self,dt)
		self.position = self.position+self.velocity
		self.velocity = self.velocity*dt
	end,
	draw = function(self,x,y,angle,sx,sy)
		self.sprite:draw(self.position.x+x,self.position.y+y,angle,sx,sy)
	end
})