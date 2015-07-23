Goal = {}
Goal.__index = Goal

setmetatable(Goal, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function Goal:create(guid,position,cfi,w,h,d)
	PickupBase.create(self, guid, position, cfi, w, h, d) 
	self.goal = false
end

function Goal:onBeginOverlap(go)
	self.goal = true
	self.level:manageList(self.guid)
	GameObjectManager:destroyGameObject(self.go)
end