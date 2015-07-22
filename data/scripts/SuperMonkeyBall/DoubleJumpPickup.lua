DoubleJumpPickup = {}
DoubleJumpPickup.__index = DoubleJumpPickup

setmetatable(DoubleJumpPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function DoubleJumpPickup:create(guid,position,cfi,w,h,d)
	PickupBase.create(self, guid, position, cfi, w, h, d)
end

function DoubleJumpPickup:onBeginOverlap(go)
	go.jumpCount = 2
end