Level1 = {}
Level1.__index = Level1

setmetatable(Level1, {
	__index = Level,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})

function Level1:setComponentStates(state)

	self.map:setComponentStates(state)
	self.goal1.go:setComponentStates(state)

end

function Level1:_init()
	Level._init(self, "level1", Vec3(0,0,-4), "data/models/map3/Map3.FBX", "data/collision/map1.hkx")
	self.goal1 = Goal("goal1", Vec3(100,100,0),0x1,20,20,20,10)
	
end