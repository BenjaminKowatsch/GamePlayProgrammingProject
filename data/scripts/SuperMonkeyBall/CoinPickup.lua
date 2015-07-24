CoinPickup = {}
CoinPickup.__index = CoinPickup

setmetatable(CoinPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

-- create game object
function CoinPickup:create(guid,position,cfi,w,h,d,level)
	PickupBase.create(self, guid, position, cfi, w, h, d,level,"data/models/Pickups/CoinPickup.fbx",Vec3(10,8,10))	
end

function CoinPickup:onBeginOverlap(go)
	go.coinCount = go.coinCount+1;	
	self.level:manageList(self.go:getGuid())
	GameObjectManager:destroyGameObject(self.go)
end
