Goal = {}
Goal.__index = Goal

setmetatable(Goal, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})



function Goal:create(guid,position,cfi,w,h,d, level)
	PickupBase.create(self, guid, position, cfi, w, h, d) 
	self.goal = false
	self.level = level
end

function Goal:onBeginOverlap(go)
	self.goal = true
	self.level:manageList(self.go:getGuid())
	GameObjectManager:destroyGameObject(self.go)
end