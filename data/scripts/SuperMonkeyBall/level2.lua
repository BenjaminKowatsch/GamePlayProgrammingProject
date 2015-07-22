Level2 = {}
Level2.__index = Level2

setmetatable(Level2, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level2:setComponentStates(state)
end

function Level2:create()
	LevelBase.create(self, "level1", Vec3(0,0,-4), "data/models/map1/Map1.FBX", "data/collision/map1.hkx")
end