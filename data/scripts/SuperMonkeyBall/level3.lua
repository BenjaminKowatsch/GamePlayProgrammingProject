Level3 = {}
Level3.__index = Level3

setmetatable(Level3, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level3:setComponentStates(state)
end

function Level3:create()
	LevelBase.create(self, "level3", Vec3(0,0,-4), "data/models/map3/Map3.FBX", "data/collision/map1.hkx")	
end