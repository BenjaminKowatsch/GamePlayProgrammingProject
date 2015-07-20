GravityPickup = {}
GravityPickup.__index = GravityPickup

setmetatable(GravityPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})

function GravityPickup:_init(guid,position,cfi,w,h,d)
	PickupBase._init(self,guid,position,cfi,w,h,d) -- super constructor call 
end

function GravityPickup:onBeginOverlap(go)
	gravityFactor = -gravityFactor
	PhysicsSystem:getWorld():setGravity(Vec3(0,0,9.8*gravityFactor))
	player.cam.camOffset.z = -player.cam.camOffset.z
	player.cam.cc:tilt(180)
end
