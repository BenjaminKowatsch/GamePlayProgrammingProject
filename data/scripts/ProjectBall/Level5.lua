Level5 = {}
Level5.__index = Level5

setmetatable(Level5, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level5:create()
	LevelBase.create(self, "level5", Vec3(0,0,-4), "data/models/Levels/Level5.FBX", "data/collision/Level5.hkx")
	--Goal
	self.goal = Goal()
	self.goal:create("goal", Vec3(0,869,300),0x1,15,15,1, self)
	self.goal.go:setRotation(Quaternion(Vec3(0,1,0),180))
	self.gameObjects[self.goal.go:getGuid()]=self.goal
	--Rotation
	self.rotplatform1 = RotationPlatform()
	self.rotplatform1:create("rotplatform1",Vec3(-413,690,15),0x1,Vec3(15.8,154,2.5),20,120,"data/models/Platforms/RotationPlatform_level5.FBX",0)
	self.gameObjects[self.rotplatform1.go:getGuid()]=self.rotplatform1
	self.rotplatform2 = RotationPlatform()
	self.rotplatform2:create("rotplatform2",Vec3(413,690,15),0x1,Vec3(15.8,154,2.5),20,120,"data/models/Platforms/RotationPlatform_level5.FBX",0)
	self.gameObjects[self.rotplatform2.go:getGuid()]=self.rotplatform2
	--Gravity
	self.gravity = GravityPickup()
	self.gravity:create("gravity",Vec3(0,507,24),0x1,5,5,5,self)
	self.gameObjects[self.gravity.go:getGuid()]=self.gravity
	--Speed
	self.speed = SpeedPickup()
	self.speed:create("speed",Vec3(0,60,5),0x1,5,5,5,self, 10)
	self.gameObjects[self.speed.go:getGuid()]=self.speed
	
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(0,423,107),0x1,2,2,2,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
	self.coin2 = CoinPickup()
	self.coin2:create("c2",Vec3(-88,507,107),0x1,2,2,2,self)
	self.gameObjects[self.coin2.go:getGuid()]=self.coin2
	self.coin3 = CoinPickup()	
	self.coin3:create("c3",Vec3(88,507,107),0x1,2,2,2,self)
	self.gameObjects[self.coin3.go:getGuid()]=self.coin3
	self.coin4 = CoinPickup()
	self.coin4:create("c4",Vec3(-262,787,24),0x1,2,2,2,self)
	self.gameObjects[self.coin4.go:getGuid()]=self.coin4
	self.coin5 = CoinPickup()
	self.coin5:create("c5",Vec3(-443,870,24),0x1,2,2,2,self)
	self.gameObjects[self.coin5.go:getGuid()]=self.coin5
	self.coin6 = CoinPickup()
	self.coin6:create("c6",Vec3(-600,671,24),0x1,2,2,2,self)
	self.gameObjects[self.coin6.go:getGuid()]=self.coin6
	self.coin7 = CoinPickup()
	self.coin7:create("c7",Vec3(-304,546,24),0x1,2,2,2,self)
	self.gameObjects[self.coin7.go:getGuid()]=self.coin7
	self.coin8 = CoinPickup()
	self.coin8:create("c8",Vec3(0,590,107),0x1,2,2,2,self)
	self.gameObjects[self.coin8.go:getGuid()]=self.coin8
	self.coin9 = CoinPickup()
	self.coin9:create("c9",Vec3(262,787,24),0x1,2,2,2,self)
	self.gameObjects[self.coin9.go:getGuid()]=self.coin9
	self.coin10 = CoinPickup()	
	self.coin10:create("c10",Vec3(443,870,24),0x1,2,2,2,self)
	self.gameObjects[self.coin10.go:getGuid()]=self.coin10
	self.coin11 = CoinPickup()
	self.coin11:create("c11",Vec3(600,671,24),0x1,2,2,2,self)
	self.gameObjects[self.coin11.go:getGuid()]=self.coin11
	self.coin12 = CoinPickup()
	self.coin12:create("c12",Vec3(304,546,24),0x1,2,2,2,self)
	self.gameObjects[self.coin12.go:getGuid()]=self.coin12
	self.coin13 = CoinPickup()
	self.coin13:create("c13",Vec3(-328,742,24),0x1,2,2,2,self)
	self.gameObjects[self.coin13.go:getGuid()]=self.coin13
	self.coin14 = CoinPickup()
	self.coin14:create("c14",Vec3(328,742,24),0x1,2,2,2,self)
	self.gameObjects[self.coin14.go:getGuid()]=self.coin14
	self.coin15 = CoinPickup()
	self.coin15:create("c15",Vec3(-413,690,24),0x1,2,2,2,self)
	self.gameObjects[self.coin15.go:getGuid()]=self.coin15
	self.coin16 = CoinPickup()
	self.coin16:create("c16",Vec3(413,690,24),0x1,2,2,2,self)
	self.gameObjects[self.coin16.go:getGuid()]=self.coin16
	self.coin17 = CoinPickup()
	self.coin17:create("c17",Vec3(-511,630,24),0x1,2,2,2,self)
	self.gameObjects[self.coin17.go:getGuid()]=self.coin17
	self.coin18 = CoinPickup()
	self.coin18:create("c18",Vec3(511,630,24),0x1,2,2,2,self)
	self.gameObjects[self.coin18.go:getGuid()]=self.coin18
end