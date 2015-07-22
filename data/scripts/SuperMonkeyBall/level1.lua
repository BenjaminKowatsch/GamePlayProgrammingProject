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
	self.gameObjects = {}
	LevelBase.create(self, "level1", Vec3(0,0,-4), "data/models/map3/Map3.FBX", "data/collision/map1.hkx")
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(40,60,0),0x1,5,5,5,self)
	self.gameObjects[self.coin1.guid]=self.coin1
	self.coin2 = CoinPickup()
	self.coin2:create("c2",Vec3(40,45,0),0x1,5,5,5,self)
	self.gameObjects[self.coin2.guid]=self.coin2
	self.coin3 = CoinPickup()	
	self.coin3:create("c3",Vec3(40,30,0),0x1,5,5,5,self)
	self.gameObjects[self.coin3.guid]=self.coin3
	self.coin4 = CoinPickup()
	self.coin4:create("c4",Vec3(40,15,0),0x1,5,5,5,self)
	self.gameObjects[self.coin4.guid]=self.coin4
	self.coin5 = CoinPickup()
	self.coin5:create("c5",Vec3(40,0,0),0x1,5,5,5,self)
	self.gameObjects[self.coin5.guid]=self.coin5	
end