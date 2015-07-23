Level2 = {}
Level2.__index = Level2

setmetatable(Level2, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level2:manageList(guid)
	self.gameObjects[guid]=nil
end

function Level2:destroy()
	GameObjectManager:destroyGameObject(self.go)
	for _, go in pairs(self.gameObjects) do
		GameObjectManager:destroyGameObject(go.go)
	end
end

function Level2:create()
	LevelBase.create(self, "level2", Vec3(0,0,-4), "data/models/Levels/Level2.FBX", "data/collision/Level2.hkx")
	--Goal
	self.goal = Goal()
	self.goal:create("goal", Vec3(0,982,0),0x1,15,15,1, self)
	self.gameObjects[self.goal.go:getGuid()]=self.goal
	--Double Jump
	self.jump1 = DoubleJumpPickup()
	self.jump1:create("jump1",Vec3(0,205,5),0x1,5,5,5,self)
	self.gameObjects[self.jump1.go:getGuid()]=self.jump1
	--Coins
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(0,772,5),0x1,2,2,2,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
	self.coin2 = CoinPickup()
	self.coin2:create("c2",Vec3(10,772,5),0x1,2,2,2,self)
	self.gameObjects[self.coin2.go:getGuid()]=self.coin2
	self.coin3 = CoinPickup()	
	self.coin3:create("c3",Vec3(-10,772,5),0x1,2,2,2,self)
	self.gameObjects[self.coin3.go:getGuid()]=self.coin3
	self.coin4 = CoinPickup()
	self.coin4:create("c4",Vec3(0,782,5),0x1,2,2,2,self)
	self.gameObjects[self.coin4.go:getGuid()]=self.coin4
	self.coin5 = CoinPickup()
	self.coin5:create("c5",Vec3(0,762,5),0x1,2,2,2,self)
	self.gameObjects[self.coin5.go:getGuid()]=self.coin5
	self.coin6 = CoinPickup()
	self.coin6:create("c6",Vec3(-54,772,5),0x1,2,2,2,self)
	self.gameObjects[self.coin6.go:getGuid()]=self.coin6
	self.coin7 = CoinPickup()
	self.coin7:create("c7",Vec3(-54,722,5),0x1,2,2,2,self)
	self.gameObjects[self.coin7.go:getGuid()]=self.coin7
	self.coin8 = CoinPickup()
	self.coin8:create("c8",Vec3(-54,672,5),0x1,2,2,2,self)
	self.gameObjects[self.coin8.go:getGuid()]=self.coin8
	self.coin9 = CoinPickup()
	self.coin9:create("c9",Vec3(54,772,5),0x1,2,2,2,self)
	self.gameObjects[self.coin9.go:getGuid()]=self.coin9
	self.coin10 = CoinPickup()	
	self.coin10:create("c10",Vec3(54,722,5),0x1,2,2,2,self)
	self.gameObjects[self.coin10.go:getGuid()]=self.coin10
	self.coin11 = CoinPickup()
	self.coin11:create("c11",Vec3(54,672,5),0x1,2,2,2,self)
	self.gameObjects[self.coin11.go:getGuid()]=self.coin11
end