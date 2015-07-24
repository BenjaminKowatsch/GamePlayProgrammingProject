SpeedPickup = {}
SpeedPickup.__index = SpeedPickup

setmetatable(SpeedPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})
-- create game object
function SpeedPickup:create(guid,position,cfi,w,h,d,level,maxTime)
	PickupBase.create(self, guid, position, cfi, w, h, d, level,"data/models/Pickups/SpeedPickup.fbx",Vec3(0.6,0.6,0.6))
	self.maxTime = maxTime
end

function SpeedPickup:onBeginOverlap(go)
	self.level:manageList(self.go:getGuid())
	go:increaseSpeed(self.maxTime)
	GameObjectManager:destroyGameObject(self.go)
end