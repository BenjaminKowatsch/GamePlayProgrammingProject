GravityPickup = {}
GravityPickup.__index = GravityPickup

setmetatable(GravityPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function GravityPickup:create(guid,position,cfi,w,h,d)
	PickupBase.create(self, guid, position, cfi, w, h, d)
end

function GravityPickup:onBeginOverlap(go)
	gravityFactor = -gravityFactor
	PhysicsSystem:getWorld():setGravity(Vec3(0,0,9.8*gravityFactor))
	player.cam.camOffset.z = -player.cam.camOffset.z
	player.cam.cc:tilt(180)
end
