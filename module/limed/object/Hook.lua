local Hook = Instance:class("Hook",3)({
	func = nil,
	event = nil,
	fire = function(self,...)
		if self.func then
			self.func(...)
		end
	end,
	disconnect = function(self)
		if self.event then
			self.event:disconnect(self)
		end
	end
})