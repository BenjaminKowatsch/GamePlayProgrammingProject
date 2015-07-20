SpeedPickup = {}
SpeedPickup.__index = SpeedPickup

setmetatable(SpeedPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})

function SpeedPickup:_init(guid,position,cfi,w,h,d)
	PickupBase._init(self,guid,position,cfi,w,h,d) -- super constructor call 
end

function SpeedPickup:onBeginOverlap(go)
	go.maxMoveSpeed = 500
end