SpeedPickup = {}
SpeedPickup.__index = SpeedPickup

setmetatable(SpeedPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function SpeedPickup:create(guid,position,cfi,w,h,d,level,maxTime)
	PickupBase.create(self, guid, position, cfi, w, h, d)
	self.maxTime = maxTime
	self.level = level
end

function SpeedPickup:onBeginOverlap(go)
	self.level:manageList(self.go:getGuid())
	go.speedTimer = true
	go.maxTime = self.maxTime
	local c = go.maxMoveSpeed
	go.maxMoveSpeed = go.speedPickupSpeed
	go.speedPickupSpeed = c
	GameObjectManager:destroyGameObject(self.go)
end