local properties = {"r","g","b","a"}
for k,v in pairs(properties) do
	properties[v] = true
end

local function clamp(r,g,b,a)
	r = r and lemon.clamp(math.floor(r)) or nil
	g = g and lemon.clamp(math.floor(g)) or nil
	b = b and lemon.clamp(math.floor(b)) or nil
	a = a and lemon.clamp(math.floor(a)) or nil
	return r,g,b,a
end

local function modify(a,b,modifier)
	local r1,g1,b1,a1 = a.r/255,a.g/255,a.b/255,a.a/255
	local r2,g2,b2,a2 = b,b,b,1
	if type(b) == "table" then
		r2,g2,b2,a2 = b.r/255,b.g/255,b.b/255,b.a/255
	end
	if modifier == "mul" then
		return clamp(
			r1*r2*255,
			g1*g2*255,
			b1*b2*255,
			a1*a2*255
		)
	elseif modifier == "div" then
		return clamp(
			r1/r2*255,
			g1/g2*255,
			b1/b2*255,
			a1/a2*255
		)
	end
end

Color = {
	__add = function(a,b)
		if type(b) == "table" then
			return Color:new(clamp(a.r+b.r,a.g+b.g,a.b+b.b,a.a+b.a))
		end
		return Color:new(clamp(a.r+b,a.g+b,a.b+b,a.a))
	end,
	__sub = function(a,b)
		if type(b) == "table" then
			return Color:new(clamp(a.r-b.r,a.g-b.g,a.b-b.b,a.a-b.a))
		end
		return Color:new(clamp(a.r-b,a.g-b,a.b-b,a.a))
	end,
	__mul = function(a,b)
		return Color:new(modify(a,b,"mul"))
	end,
	__div = function(a,b)
		return Color:new(modify(a,b,"div"))
	end,
	__pow = function(a,b)
		if type(b) == "table" then
			return Color:new(clamp(a.r^b.r,a.g^b.g,a.b^b.b,a.a^b.a))
		end
		return Color:new(clamp(a.r^b,a.g^b,a.b^b,a.a))
	end,
	__eq = function(a,b)
		if type(b) == "table" then
			return a.r == b.r and a.g == b.g and a.b == b.b and a.a == b.a
		end
		return false
	end,
	__index = function(self,i)
		if properties[i] then
			return rawget(self,"d"..i)
		end
	end,
	__newindex = function(self,i,v)
		if properties[i] and self["d"..i] ~= v then
			rawset(self,i,nil)
			rawset(self,"d"..i,v)
		end
	end,
	__tostring = function(self)
		return self.dr..", "..self.dg..", "..self.db..", "..self.da
	end
}

function Color:new(r,g,b,a)
	return setmetatable(
		{
			dr = r or 0,
			dg = g or 0,
			db = b or 0,
			da = a or 255,
			components = function(self)
				return self.dr,self.dg,self.db,self.da
			end,
			clone = function(self)
				return Color:new(self.dr,self.dg,self.db,self.da)
			end
		},
		Color
	)
end