CoinPickup = {}
CoinPickup.__index = CoinPickup

setmetatable(CoinPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function CoinPickup:create(guid,position,cfi,w,h,d)
	PickupBase.create(self, guid, position, cfi, w, h, d)
	self.guid = guid
	
end

function CoinPickup:onBeginOverlap(go)
	go.coinCount = go.coinCount+1;
end
