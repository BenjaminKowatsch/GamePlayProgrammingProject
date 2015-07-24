Level4 = {}
Level4.__index = Level4

setmetatable(Level4, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})


function Level4:create()
	LevelBase.create(self, "level4", Vec3(0,0,-4), "data/models/Levels/Level4.FBX", "data/collision/Level4.hkx")
	
	--Goal
	self.goal = Goal()
	self.goal:create("goal", Vec3(-3.5,-306,0),0x1,15,15,1, self)
	self.gameObjects[self.goal.go:getGuid()]=self.goal
	--Speed
	self.speed = SpeedPickup()
	self.speed:create("speed",Vec3(-327,1233,5),0x1,5,5,5,self, 20)
	self.gameObjects[self.speed.go:getGuid()]=self.speed
	--Double Jump
	self.jump = DoubleJumpPickup()
	self.jump:create("jump",Vec3(0,1039,5),0x1,5,5,5,self)
	self.gameObjects[self.jump.go:getGuid()]=self.jump
	--Coins
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(0,478,5),0x1,2,2,2,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
	self.coin2 = CoinPickup()
	self.coin2:create("c2",Vec3(0,664,5),0x1,2,2,2,self)
	self.gameObjects[self.coin2.go:getGuid()]=self.coin2
	self.coin3 = CoinPickup()	
	self.coin3:create("c3",Vec3(0,315,5),0x1,2,2,2,self)
	self.gameObjects[self.coin3.go:getGuid()]=self.coin3
	self.coin4 = CoinPickup()
	self.coin4:create("c4",Vec3(275,478,5),0x1,2,2,2,self)
	self.gameObjects[self.coin4.go:getGuid()]=self.coin4
	self.coin5 = CoinPickup()
	self.coin5:create("c5",Vec3(-275,478,5),0x1,2,2,2,self)
	self.gameObjects[self.coin5.go:getGuid()]=self.coin5
	self.coin6 = CoinPickup()
	self.coin6:create("c6",Vec3(192,737,5),0x1,2,2,2,self)
	self.gameObjects[self.coin6.go:getGuid()]=self.coin6
	self.coin7 = CoinPickup()
	self.coin7:create("c7",Vec3(250,664,5),0x1,2,2,2,self)
	self.gameObjects[self.coin7.go:getGuid()]=self.coin7
	self.coin8 = CoinPickup()
	self.coin8:create("c8",Vec3(283,574,5),0x1,2,2,2,self)
	self.gameObjects[self.coin8.go:getGuid()]=self.coin8
	self.coin9 = CoinPickup()
	self.coin9:create("c9",Vec3(250,388,5),0x1,2,2,2,self)
	self.gameObjects[self.coin9.go:getGuid()]=self.coin9
	self.coin10 = CoinPickup()	
	self.coin10:create("c10",Vec3(192,315,5),0x1,2,2,2,self)
	self.gameObjects[self.coin10.go:getGuid()]=self.coin10
	self.coin11 = CoinPickup()
	self.coin11:create("c11",Vec3(-192,737,5),0x1,2,2,2,self)
	self.gameObjects[self.coin11.go:getGuid()]=self.coin11
	self.coin12 = CoinPickup()
	self.coin12:create("c12",Vec3(-250,664,5),0x1,2,2,2,self)
	self.gameObjects[self.coin12.go:getGuid()]=self.coin12
	self.coin13 = CoinPickup()
	self.coin13:create("c13",Vec3(-283,574,5),0x1,2,2,2,self)
	self.gameObjects[self.coin13.go:getGuid()]=self.coin13
	self.coin14 = CoinPickup()
	self.coin14:create("c14",Vec3(-250,388,5),0x1,2,2,2,self)
	self.gameObjects[self.coin14.go:getGuid()]=self.coin14
	self.coin15 = CoinPickup()	
	self.coin15:create("c15",Vec3(-192,315,5),0x1,2,2,2,self)
	self.gameObjects[self.coin15.go:getGuid()]=self.coin15
end