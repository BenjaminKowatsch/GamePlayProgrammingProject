GravityPickup = {}
GravityPickup.__index = GravityPickup

setmetatable(GravityPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

-- create game object
function GravityPickup:create(guid,position,cfi,w,h,d,level)
	PickupBase.create(self, guid, position, cfi, w, h, d,level,"data/models/Pickups/GravityPickup.fbx",Vec3(2,2,2))
end

function GravityPickup:onBeginOverlap(go)
	-- switch gravity and adjust camera rotation and position
	setGravity(-gravityFactor)
	self.level:manageList(self.go:getGuid())
	GameObjectManager:destroyGameObject(self.go)
end
