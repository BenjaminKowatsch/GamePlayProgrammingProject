Level3 = {}
Level3.__index = Level3

setmetatable(Level3, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level3:manageList(guid)
	self.gameObjects[guid]=nil
end

function Level3:destroy()
	GameObjectManager:destroyGameObject(self.map)
	for _, go in pairs(self.gameObjects) do
		GameObjectManager:destroyGameObject(go.go)
	end
end

function Level3:create()
	LevelBase.create(self, "level3", Vec3(0,0,-4), "data/models/Levels/Level3.FBX", "data/collision/Level3.hkx")
	
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(40,60,0),0x1,5,5,5,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
end