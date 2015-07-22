Level4 = {}
Level4.__index = Level4

setmetatable(Level4, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level4:destroy()
	GameObjectManager:destroyGameObject(self.map)
end

function Level4:create()
	LevelBase.create(self, "level4", Vec3(0,0,-4), "data/models/map1/Map1.FBX", "data/collision/map1.hkx")
end