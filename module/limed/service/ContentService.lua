local cache = {}

local ContentService = Instance:class("ContentService",2)({
	loadImage = function(self,source)
		if not cache.Image then
			cache.Image = {}
		end
		if not cache.Image[source] then
			cache.Image[source] = love.graphics.newImage(source)
			cache.Image[source]:setFilter("nearest","nearest")
		end
		return self:new("Image",function(t)
			t.image = cache.Image[source]
			t.width = t.image:getWidth()
			t.height = t.image:getHeight()
		end)
	end,
	loadFont = function(self,source,size)
		if not cache.Font then
			cache.Font = {}
		end
		if not cache.Font[size] then
			cache.Font[size] = {}
		end
		if not cache.Font[size][source] then
			cache.Font[size][source] = love.graphics.newFont(source,size)
		end
		return self:new("FontAsset",function(t)
			t.font = cache.Font[size][source]
		end)
	end,
	getFont = function(self)
		return self:new("FontAsset",function(t)
			t.font = love.graphics.getFont()
		end)
	end
})