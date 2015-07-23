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
	GameObjectManager:destroyGameObject(self.map)
	for _, go in pairs(self.gameObjects) do
		GameObjectManager:destroyGameObject(go.go)
	end
end

function Level2:create()
	LevelBase.create(self, "level2", Vec3(0,0,-4), "data/models/Levels/Level2.FBX", "data/collision/Level2.hkx")
	
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(40,60,0),0x1,5,5,5,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
end