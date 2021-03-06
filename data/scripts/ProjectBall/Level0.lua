Level0 = {}
Level0.__index = Level0

setmetatable(Level0, {
	__index = LevelBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Level0:create()
	LevelBase.create(self, "level0", Vec3(0,0,-4), "data/models/Levels/Level0.FBX", "data/collision/Level0.hkx")
	
	self.glevel1 = Goal()
	self.glevel1:create("glevel1", Vec3(-118,139,0),0x1,15,15,1, self)
	self.glevel1.go:setRotation(Quaternion(Vec3(0,0,1),90))
	self.gameObjects[self.glevel1.go:getGuid()]=self.glevel1
	self.glevel2 = Goal()
	self.glevel2:create("glevel2", Vec3(-73,205,0),0x1,15,15,1, self)
	self.gameObjects[self.glevel2.go:getGuid()]=self.glevel2
	self.glevel3 = Goal()
	self.glevel3:create("glevel3", Vec3(-31,205,0),0x1,15,15,1, self)
	self.gameObjects[self.glevel3.go:getGuid()]=self.glevel3
	self.glevel4 = Goal()
	self.glevel4:create("glevel4", Vec3(26,205,0),0x1,15,15,1, self)
	self.gameObjects[self.glevel4.go:getGuid()]=self.glevel4
	self.glevel5 = Goal()
	self.glevel5:create("glevel5", Vec3(70,205,0),0x1,15,15,1, self)
	self.gameObjects[self.glevel5.go:getGuid()]=self.glevel5
end
