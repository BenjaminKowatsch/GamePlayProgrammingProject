Level1 = {}
Level1.__index = Level1

setmetatable(Level1, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level1:setComponentStates(state)
end

function Level1:create()
	LevelBase.create(self, "level1", Vec3(0,0,-4), "data/models/map3/Map3.FBX", "data/collision/map1.hkx")	
end