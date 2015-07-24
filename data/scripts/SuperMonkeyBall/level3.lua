Level3 = {}
Level3.__index = Level3

setmetatable(Level3, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level3:create()
	LevelBase.create(self, "level3", Vec3(0,0,-4), "data/models/Levels/Level3.FBX", "data/collision/Level3.hkx")
	--Goal
	self.goal = Goal()
	self.goal:create("goal", Vec3(83.118,370.913,9.776),0x1,15,15,1, self)
	self.gameObjects[self.goal.go:getGuid()]=self.goal
	--Gravity
	self.gravity1 = GravityPickup()
	self.gravity1:create("gravity1",Vec3(-619,677,-60),0x1,5,5,5,self)
	self.gameObjects[self.gravity1.go:getGuid()]=self.gravity1
	self.gravity2 = GravityPickup()
	self.gravity2:create("gravity2",Vec3(83.118,370.913,74),0x1,5,5,5,self)
	self.gameObjects[self.gravity2.go:getGuid()]=self.gravity2
	--Speed
	self.speed = SpeedPickup()
	self.speed:create("speed",Vec3(-589,687,210),0x1,5,5,5,self, 4)
	self.gameObjects[self.speed.go:getGuid()]=self.speed
	--Double Jump
	self.jump = DoubleJumpPickup()
	self.jump:create("jump",Vec3(83.118,519.367,74),0x1,5,5,5,self)
	self.gameObjects[self.jump.go:getGuid()]=self.jump
	-- Moving platform_Small size = Vec3(19.5,19.5,3.5)
	-- Moving platform_Big  size = Vec3(25.8,25.8,3.5)
	-- RoationPlatform_Big size  = Vec3(12,78.5,3.5)
	-- RoationPlatform_Small size = Vec3(9.8,59,3.5)
	--Moving Platforms
	self.movplatform1 = MovingPlatform()
	self.movplatform1:create("movplatform1",Vec3(-231.448,222.883,-79.175),0x1,Vec3(25.8,25.8,3.5),1800,Vec3(-300.448,222.883,-79.175),"data/models/Platforms/MovingPlatform_Big.FBX")
	self.gameObjects[self.movplatform1.go:getGuid()]=self.movplatform1
	
	self.movplatform2 = MovingPlatform()
	self.movplatform2:create("movplatform2",Vec3(-339.448,162.883,-79.175),0x1,Vec3(19.5,19.5,3.5),1700,Vec3(-339.448,282.883,-79.175),"data/models/Platforms/MovingPlatform_Small.FBX")
	self.gameObjects[self.movplatform2.go:getGuid()]=self.movplatform2
	
	self.movplatform3 = MovingPlatform()
	self.movplatform3:create("movplatform3",Vec3(-393.448,282.883,-79.175),0x1,Vec3(19.5,19.5,3.5),1700,Vec3(-393.448,162.883,-79.175),"data/models/Platforms/MovingPlatform_Small.FBX")
	self.gameObjects[self.movplatform3.go:getGuid()]=self.movplatform3
	
	self.movplatform4 = MovingPlatform()
	self.movplatform4:create("movplatform4",Vec3(-448.448,162.883,-79.175),0x1,Vec3(19.5,19.5,3.5),1700,Vec3(-448.448,282.883,-79.175),"data/models/Platforms/MovingPlatform_Small.FBX")
	self.gameObjects[self.movplatform4.go:getGuid()]=self.movplatform4
	
	self.movplatform5 = MovingPlatform()
	self.movplatform5:create("movplatform5",Vec3(-339.448,252.883,-79.175),0x1,Vec3(19.5,19.5,3.5),1700,Vec3(-339.448,372.883,-79.175),"data/models/Platforms/MovingPlatform_Small.FBX")
	self.gameObjects[self.movplatform5.go:getGuid()]=self.movplatform5
	
	self.movplatform6 = MovingPlatform()
	self.movplatform6:create("movplatform6",Vec3(-393.448,372.883,-79.175),0x1,Vec3(19.5,19.5,3.5),1700,Vec3(-393.448,252.883,-79.175),"data/models/Platforms/MovingPlatform_Small.FBX")
	self.gameObjects[self.movplatform6.go:getGuid()]=self.movplatform6
	
	self.movplatform7 = MovingPlatform()
	self.movplatform7:create("movplatform7",Vec3(-520.448,462.883,-79.175),0x1,Vec3(25.8,25.8,3.5),1800,Vec3(-520.448,552.883,-79.175),"data/models/Platforms/MovingPlatform_Big.FBX")
	self.gameObjects[self.movplatform7.go:getGuid()]=self.movplatform7
	
	self.movplatform8 = MovingPlatform()
	self.movplatform8:create("movplatform8",Vec3(-620.448,462.883,-79.175),0x1,Vec3(25.8,25.8,3.5),1800,Vec3(-620.448,552.883,-79.175),"data/models/Platforms/MovingPlatform_Big.FBX")
	self.gameObjects[self.movplatform8.go:getGuid()]=self.movplatform8
	
	self.movplatform9 = MovingPlatform()
	self.movplatform9:create("movplatform9",Vec3(-448.448,252.883,-79.175),0x1,Vec3(19.5,19.5,3.5),1700,Vec3(-448.448,372.883,-79.175),"data/models/Platforms/MovingPlatform_Small.FBX")
	self.gameObjects[self.movplatform9.go:getGuid()]=self.movplatform9
	
	self.movplatform10 = MovingPlatform()
	self.movplatform10:create("movplatform10",Vec3(-471.448,492.883,-79.175),0x1,Vec3(25.8,25.8,3.5),1800,Vec3(-231.448,492.883,-79.175),"data/models/Platforms/MovingPlatform_Big.FBX")
	self.gameObjects[self.movplatform10.go:getGuid()]=self.movplatform10
	
	self.movplatform11 = MovingPlatform()
	self.movplatform11:create("movplatform11",Vec3(-231.448,422.883,-79.175),0x1,Vec3(25.8,25.8,3.5),1800,Vec3(-471.448,422.883,-79.175),"data/models/Platforms/MovingPlatform_Big.FBX")
	self.gameObjects[self.movplatform11.go:getGuid()]=self.movplatform11
	
	self.rotplatform1 = RotationPlatform()
	self.rotplatform1:create("rotplatform1",Vec3(-530.448,162.883,-79.175),0x1,Vec3(9.8,59,3.5),20,40,"data/models/Platforms/RotationPlatform_Small.FBX",90)
	self.gameObjects[self.rotplatform1.go:getGuid()]=self.rotplatform1
	
	self.rotplatform2 = RotationPlatform()
	self.rotplatform2:create("rotplatform2",Vec3(-540.448,342.883,-79.175),0x1,Vec3(12,78.5,3.5),20,45,"data/models/Platforms/RotationPlatform_Big.FBX",0)
	self.gameObjects[self.rotplatform2.go:getGuid()]=self.rotplatform2
	
	self.rotplatform3 = RotationPlatform()
	self.rotplatform3:create("rotplatform3",Vec3(-550.448,242.883,-79.175),0x1,Vec3(12,78.5,3.5),20,20,"data/models/Platforms/RotationPlatform_Big.FBX",90)
	self.gameObjects[self.rotplatform3.go:getGuid()]=self.rotplatform3
	--Coins
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(73,519,74),0x1,2,2,2,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
	self.coin2 = CoinPickup()
	self.coin2:create("c2",Vec3(93,519,74),0x1,2,2,2,self)
	self.gameObjects[self.coin2.go:getGuid()]=self.coin2
	self.coin3 = CoinPickup()	
	self.coin3:create("c3",Vec3(83,509,74),0x1,2,2,2,self)
	self.gameObjects[self.coin3.go:getGuid()]=self.coin3
	self.coin4 = CoinPickup()
	self.coin4:create("c4",Vec3(83,529,74),0x1,2,2,2,self)
	self.gameObjects[self.coin4.go:getGuid()]=self.coin4
	self.coin5 = CoinPickup()
	self.coin5:create("c5",Vec3(73,591,84),0x1,2,2,2,self)
	self.gameObjects[self.coin5.go:getGuid()]=self.coin5
	self.coin6 = CoinPickup()
	self.coin6:create("c6",Vec3(93,591,84),0x1,2,2,2,self)
	self.gameObjects[self.coin6.go:getGuid()]=self.coin6
	self.coin7 = CoinPickup()
	self.coin7:create("c7",Vec3(83,601,84),0x1,2,2,2,self)
	self.gameObjects[self.coin7.go:getGuid()]=self.coin7
	self.coin8 = CoinPickup()
	self.coin8:create("c8",Vec3(83,581,84),0x1,2,2,2,self)
	self.gameObjects[self.coin8.go:getGuid()]=self.coin8
	self.coin9 = CoinPickup()
	self.coin9:create("c9",Vec3(93,671,94),0x1,5,5,5,self)
	self.gameObjects[self.coin9.go:getGuid()]=self.coin9
	self.coin10 = CoinPickup()	
	self.coin10:create("c10",Vec3(73,671,94),0x1,5,5,5,self)
	self.gameObjects[self.coin10.go:getGuid()]=self.coin10
	self.coin11 = CoinPickup()
	self.coin11:create("c11",Vec3(83,681,94),0x1,5,5,5,self)
	self.gameObjects[self.coin11.go:getGuid()]=self.coin11
	self.coin12 = CoinPickup()
	self.coin12:create("c12",Vec3(83,661,94),0x1,5,5,5,self)
	self.gameObjects[self.coin12.go:getGuid()]=self.coin12
	self.coin13 = CoinPickup()
	self.coin13:create("c13",Vec3(-629,687,210),0x1,5,5,5,self)
	self.gameObjects[self.coin13.go:getGuid()]=self.coin13
	self.coin14 = CoinPickup()
	self.coin14:create("c14",Vec3(-619,687,210),0x1,5,5,5,self)
	self.gameObjects[self.coin14.go:getGuid()]=self.coin14
	self.coin15 = CoinPickup()	
	self.coin15:create("c15",Vec3(-619,667,210),0x1,5,5,5,self)
	self.gameObjects[self.coin15.go:getGuid()]=self.coin15
	self.coin16 = CoinPickup()
	self.coin16:create("c16",Vec3(-619,687,210),0x1,5,5,5,self)
	self.gameObjects[self.coin16.go:getGuid()]=self.coin16
	self.coin17 = CoinPickup()
	self.coin17:create("c17",Vec3(40,0,0),0x1,5,5,5,self)
	self.gameObjects[self.coin17.go:getGuid()]=self.coin17
	self.coin18 = CoinPickup()
	self.coin18:create("c18",Vec3(40,60,0),0x1,5,5,5,self)
	self.gameObjects[self.coin18.go:getGuid()]=self.coin18
	self.coin19 = CoinPickup()
	self.coin19:create("c19",Vec3(40,45,0),0x1,5,5,5,self)
	self.gameObjects[self.coin19.go:getGuid()]=self.coin19
	self.coin20 = CoinPickup()
	self.coin20:create("c20",Vec3(40,45,0),0x1,5,5,5,self)
	self.gameObjects[self.coin20.go:getGuid()]=self.coin20
end