Level1 = {}
Level1.__index = Level1

setmetatable(Level1, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level1:create()
	LevelBase.create(self, "level1", Vec3(0,0,-4), "data/models/Levels/Level1.FBX", "data/collision/Level1.hkx")
	--Goal
	self.goal = Goal()
	self.goal:create("goal", Vec3(190,190,1),0x1,15,15,1, self)
	self.gameObjects[self.goal.go:getGuid()]=self.goal
	--Double Jump
	self.jump = DoubleJumpPickup()
	self.jump:create("jump",Vec3(0,290,10),0x1,5,5,5,self)
	self.gameObjects[self.jump.go:getGuid()]=self.jump
	--Speed
	self.speed = SpeedPickup()
	self.speed:create("speed",Vec3(50,554,10),0x1,5,5,5,self, 10)
	self.gameObjects[self.speed.go:getGuid()]=self.speed
	--Coins
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(0,554,10),0x1,5,5,5,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
	self.coin2 = CoinPickup()
	self.coin2:create("c2",Vec3(0,425,31),0x1,5,5,5,self)
	self.gameObjects[self.coin2.go:getGuid()]=self.coin2
	self.coin3 = CoinPickup()	
	self.coin3:create("c3",Vec3(189,388,10),0x1,5,5,5,self)
	self.gameObjects[self.coin3.go:getGuid()]=self.coin3
	self.coin4 = CoinPickup()
	self.coin4:create("c4",Vec3(189,348,10),0x1,5,5,5,self)
	self.gameObjects[self.coin4.go:getGuid()]=self.coin4
	self.coin5 = CoinPickup()
	self.coin5:create("c5",Vec3(189,308,10),0x1,5,5,5,self)
	self.gameObjects[self.coin5.go:getGuid()]=self.coin5
	
end