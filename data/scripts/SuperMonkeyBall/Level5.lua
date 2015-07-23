Level5 = {}
Level5.__index = Level5

setmetatable(Level5, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level5:manageList(guid)
	self.gameObjects[guid]=nil
end

function Level5:destroy()
	GameObjectManager:destroyGameObject(self.go)
	for _, go in pairs(self.gameObjects) do
		GameObjectManager:destroyGameObject(go.go)
	end
end

function Level5:create()
	LevelBase.create(self, "level5", Vec3(0,0,-4), "data/models/Levels/Level5.FBX", "data/collision/Level5.hkx")
	
	self.coin1 = CoinPickup()
	self.coin1:create("c1",Vec3(40,60,0),0x1,5,5,5,self)
	self.gameObjects[self.coin1.go:getGuid()]=self.coin1
end