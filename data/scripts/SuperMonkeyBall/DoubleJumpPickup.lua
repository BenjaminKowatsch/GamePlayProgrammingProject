DoubleJumpPickup = {}
DoubleJumpPickup.__index = DoubleJumpPickup

setmetatable(DoubleJumpPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})

function DoubleJumpPickup:_init(guid,position,cfi,w,h,d)
	PickupBase._init(self,guid,position,cfi,w,h,d) -- super constructor call 
end

function DoubleJumpPickup:onBeginOverlap(go)
	--PickupBase.onBeginOverlap(go)
	go.jumpCount = 2
end

--function DoubleJumpPickup:onEndOverlap(go)
--	--PickupBase.onEndOverlap(go)
--	--logMessage("EndOverlap Child")
--end