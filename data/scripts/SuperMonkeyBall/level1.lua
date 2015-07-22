Level1 = {}
Level1.__index = Level1

setmetatable(Level1, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level1:manageList(guid)
	self.gameObjects[guid]=nil
end

function Level1:destroy()
	GameObjectManager:destroyGameObject(self.map)
	for _, go in pairs(self.gameObjects) do
		GameObjectManager:destroyGameObject(go.go)
	end
end

function Level1:create()
	LevelBase.create(self, "level1", Vec3(0,0,-4), "data/models/Level3/Level3.FBX", "data/collision/Level3.hkx")
	self.speedPickup1 = SpeedPickup()
	self.speedPickup1:create("SpeedPickup",Vec3(60,80,30),0x1,15,15,15,self,2)
	self.gameObjects[self.speedPickup1.go:getGuid()]=self.speedPickup1
	
	--self.rotplatform = RotationPlatform()
	--self.rotplatform:create("rotplatform",Vec3(60,-60,20),0x1,60,60,5,40,40)
	--self.gameObjects[self.rotplatform.go:getGuid()]=self.rotplatform
	
	self.movplatform = MovingPlatform()
	self.movplatform:create("movplatform",Vec3(60,80,-4),0x1,30,30,5,1600,Vec3(60,120,30))
	self.gameObjects[self.movplatform.go:getGuid()]=self.movplatform
	
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(40,60,0),0x1,5,5,5,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
	self.coin2 = CoinPickup()
	self.coin2:create("c2",Vec3(40,45,0),0x1,5,5,5,self)
	self.gameObjects[self.coin2.go:getGuid()]=self.coin2
	self.coin3 = CoinPickup()	
	self.coin3:create("c3",Vec3(40,30,0),0x1,5,5,5,self)
	self.gameObjects[self.coin3.go:getGuid()]=self.coin3
	self.coin4 = CoinPickup()
	self.coin4:create("c4",Vec3(40,15,0),0x1,5,5,5,self)
	self.gameObjects[self.coin4.go:getGuid()]=self.coin4
	self.coin5 = CoinPickup()
	self.coin5:create("c5",Vec3(40,0,0),0x1,5,5,5,self)
	self.gameObjects[self.coin5.go:getGuid()]=self.coin5	
end