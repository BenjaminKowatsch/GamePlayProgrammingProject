CoinPickup = {}
CoinPickup.__index = CoinPickup

setmetatable(CoinPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})

function CoinPickup:_init(guid,position,cfi,w,h,d)
	PickupBase._init(self,guid,position,cfi,w,h,d) -- super constructor call 
	self.guid = guid
	
end

function CoinPickup:onBeginOverlap(go)
	go.coinCount = go.coinCount+1;
	GameObjectManager:destroyGameObject(self.go)
end
