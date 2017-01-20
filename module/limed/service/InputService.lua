local InputService = Instance:class("InputService",2)({
	modifier = {},
	isShift = function(self)
		return self.modifier.lshift == true or self.modifier.rshift == true
	end,
	isCtrl = function(self)
		return self.modifier.lctrl == true or self.modifier.rctrl == true
	end,
	isAlt = function(self)
		return self.modifier.lalt == true or self.modifier.ralt == true
	end,
	keyDown = Instance:event(),
	keyUp = Instance:event(),
	mouseDown = Instance:event(),
	mouseUp = Instance:event(),
	mouseMoved = Instance:event(),
	mouseWheel = Instance:event(),
	touchDown = Instance:event(),
	touchUp = Instance:event(),
	touchMoved = Instance:event()
})

local modifier = {"lshift","rshift","lctrl","rctrl","lalt","ralt"}
for k,v in pairs(modifier) do
	modifier[v] = true
end

InputService.keyDown:connect(function(key)
	if modifier[key] then
		InputService.modifier[key] = true
	end
end)

InputService.keyUp:connect(function(key)
	if modifier[key] then
		InputService.modifier[key] = nil
	end
end)

function love.keypressed(...)
	InputService.keyDown:fire(...)
end

function love.keyreleased(...)
	InputService.keyUp:fire(...)
end

function love.mousepressed(...)
	InputService.mouseDown:fire(...)
end

function love.mousereleased(...)
	InputService.mouseUp:fire(...)
end

function love.mousemoved(...)
	InputService.mouseMoved:fire(...)
end

function love.mousewheel(...)
	InputService.mouseWheel:fire(...)
end

function love.touchpressed(...)
	InputService.touchDown:fire(...)
end

function love.touchreleased(...)
	InputService.touchUp:fire(...)
end

function love.touchmoved(...)
	InputService.touchMoved:fire(...)
end