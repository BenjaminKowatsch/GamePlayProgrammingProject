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
	if state == 2 then
		self.coinPickup6.go:setComponentStates(state)
		self.coinPickup7.go:setComponentStates(state)
		self.coinPickup8.go:setComponentStates(state)
		self.coinPickup9.go:setComponentStates(state)
		self.coinPickup10.go:setComponentStates(state)
	else
		GameObjectManager:createGameObjectUninitialized(guid)
	
end

function Level2:_init()
	Level._init(self, "level2", Vec3(0,0,-4), "data/models/map1/Map1.FBX", "data/collision/map1.hkx")
	self.goal2 = Goal("goal2", Vec3(100,100,0),0x1,20,20,20,10)
	self.coinPickup6 = CoinPickup("CoinPickup6", Vec3(100,30,0),0x1,5,5,5,4)
	self.coinPickup7 = CoinPickup("CoinPickup7", Vec3(100,40,0),0x1,5,5,5,4)
	self.coinPickup8 = CoinPickup("CoinPickup8", Vec3(100,50,0),0x1,5,5,5,4)
	self.coinPickup9 = CoinPickup("CoinPickup9", Vec3(100,60,0),0x1,5,5,5,4)
	self.coinPickup10 = CoinPickup("CoinPickup10", Vec3(100,70,0),0x1,5,5,5,4)	
	
end