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
	self.coinPickup.go:setComponentStates(state)
	self.coinPickup2.go:setComponentStates(state)
	self.coinPickup3.go:setComponentStates(state)
	self.coinPickup4.go:setComponentStates(state)
	self.coinPickup5.go:setComponentStates(state)


end

function Level1:_init()
	Level._init(self, "level1", Vec3(0,0,-4), "data/models/map3/Map3.FBX", "data/collision/map1.hkx")
	self.goal1 = Goal("goal1", Vec3(100,100,0),0x1,20,20,20,10)
	self.coinPickup = CoinPickup("CoinPickup", Vec3(100,30,0),0x1,5,5,5,4)
	self.coinPickup2 = CoinPickup("CoinPickup2", Vec3(100,40,0),0x1,5,5,5,4)
	self.coinPickup3 = CoinPickup("CoinPickup3", Vec3(100,50,0),0x1,5,5,5,4)
	self.coinPickup4 = CoinPickup("CoinPickup4", Vec3(100,60,0),0x1,5,5,5,4)
	self.coinPickup5 = CoinPickup("CoinPickup5", Vec3(100,70,0),0x1,5,5,5,4)
	
end