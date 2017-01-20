local module = {
	"math",
	"reference",
	"object",
	"service"
}

local path = (...) and (...):gsub("%.init$",""):gsub("%.","/") or ""

local class = {}

Instance = {}
Instance.__index = Instance

local function copy(t,to,meta)
	local n = to or {}
	for k,v in pairs(t) do
		if type(v) == "table" and v ~= t then
			n[k] = copy(v)
		else n[k] = v
		end
	end

	return meta and n or setmetatable(n,getmetatable(t))
end

function Instance:class(name,security)
	if not class[name] then
		security = security or 3
		return function(t)
			t = t or {}
			t.__index = t

			t.name = function()
				return name
			end
			t.security = function()
				return security
			end
			t.is = function(t,name)
				return t:name() == name or self:is(name)
			end
			local construct = t.new
			t.construct = function(t,prop)
				local n = setmetatable(self:construct(),t)

				for k,v in pairs(t) do
					if v == Instance.event then
						n[k] = v()
					elseif type(v) == "table" and v ~= t then
						n[k] = copy(v)
					end
				end
				if construct then
					construct(n)
				end
				if prop then
					prop(n)
				end
				return n
			end
			t.new = function(t,ref,prop)
				if class[ref] then
					if (security == 2 and class[ref]:security() == 4) then
						return class[ref]:construct(prop)
					elseif class[ref]:is(name) and ref ~= name then
						return class[ref]:construct(function(n)
							local meta = getmetatable(t)
							setmetatable(t,{})
							copy(t,n,true)
							setmetatable(t,meta)
							if prop then
								prop(n)
							end
						end)
					end
				end
				return Instance:new(ref,prop)
			end
			t.clone = function(t,prop)
				local meta = getmetatable(t)
				setmetatable(t,{})
				local n = setmetatable(copy(t),meta)
				setmetatable(t,meta)
				if prop then
					prop(n)
				end
				return n
			end
			local destroy = t.destroy or Instance.destroy
			t.destroy = function(t)
				self.destroy(t)
				destroy(t)
			end

			local update = t.update or Instance.update
			t.update = rawget(t,"__update") and update or function(t,dt)
				self.update(t,dt)
				update(t,dt)
			end
			local draw = t.draw or Instance.draw
			t.draw = rawget(t,"__draw") and draw or function(t,...)
				self.draw(t,...)
				draw(t,...)
			end

			class[name] = setmetatable(t,self)

			return t
		end
	else print("Class '"..name.."' already exists!")
	end
end

function Instance:event()
	return {
		hook = {},
		fire = function(self,...)
			for k,v in pairs(self.hook) do
				if v then
					k:fire(...)
				else self.hook[k] = nil
				end
			end
		end,
		connect = function(self,func)
			local v = Instance:new("Hook")
			v.event = self
			v.func = func
			self.hook[v] = true

			return v
		end,
		disconnect = function(self,hook)
			if self.hook[hook] then
				self.hook[hook] = nil
			end
		end,
		disconnectAll = function(self)
			self.hook = {}
		end
	}
end

function Instance:new(name,prop)
	if name and class[name] then
		if class[name]:security() == 3 then
			return class[name]:construct(prop)
		else print("Unable to instantiate class '"..name.."'. Security level is "..class[name]:security()..".")
		end
	else print("Class '"..name.."' does not exist!")
	end
end

function Instance:service(name)
	if class[name] and class[name]:security() == 2 then
		return class[name]
	end
end

function Instance:name()
	return "Instance"
end

function Instance:is(name)
	return self:name() == name
end

function Instance:security()
	return 1
end

function Instance:destroy() end

function Instance:update() end

function Instance:draw() end

function Instance:construct()
	return setmetatable({},self)
end

for _,t in pairs(module) do
	for _,v in pairs(love.filesystem.getDirectoryItems(path.."/"..t)) do
		require(path.."."..t.."."..v:gsub("%.lua$",""))
	end
end