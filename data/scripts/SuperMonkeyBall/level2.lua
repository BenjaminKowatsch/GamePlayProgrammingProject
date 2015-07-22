Level2 = {}
Level2.__index = Level2

setmetatable(Level2, {
	__index = Level,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})

function Level2:setComponentStates(state)

	self.map:setComponentStates(state)
	self.goal2.go:setComponentStates(state)
	
end

function Level2:_init()
	Level._init(self, "level2", Vec3(0,0,-4), "data/models/map1/Map1.FBX", "data/collision/map1.hkx")
	self.goal2 = Goal("goal2", Vec3(100,100,0),0x1,20,20,20,10)	
	
end