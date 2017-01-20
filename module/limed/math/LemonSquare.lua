lemon = {}
lemon.__index = lemon

function lemon.clamp(a,b,v)
	return math.max(a or 0,math.min(v or 0,b or 0))
end

function lemon.tableInit(t,...)
	for _,v in pairs({...}) do
		if not t[v] then
			t[v] = {}
		end
		t = t[v]
	end

	return t
end