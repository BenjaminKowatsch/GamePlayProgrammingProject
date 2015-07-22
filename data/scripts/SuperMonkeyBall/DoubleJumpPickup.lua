DoubleJumpPickup = {}
DoubleJumpPickup.__index = DoubleJumpPickup

setmetatable(DoubleJumpPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function DoubleJumpPickup:create(guid,position,cfi,w,h,d,level)
	PickupBase.create(self, guid, position, cfi, w, h, d)
end

function DoubleJumpPickup:onBeginOverlap(go)
	go.jumpCount = 2
	self.level:manageList(self.guid)
	GameObjectManager:destroyGameObject(self.go)
end