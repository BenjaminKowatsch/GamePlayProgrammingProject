Level4 = {}
Level4.__index = Level4

setmetatable(Level4, {
	__index = Level,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})

function Level4:setComponentStates(state)

	self.map:setComponentStates(state)
	
	

end

function Level4:_init()
	Level._init(self, "level4", Vec3(0,0,-4), "data/models/map1/Map1.FBX", "data/collision/map1.hkx")
	
	
end