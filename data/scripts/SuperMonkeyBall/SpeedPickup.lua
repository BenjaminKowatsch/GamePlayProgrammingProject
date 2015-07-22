SpeedPickup = {}
SpeedPickup.__index = SpeedPickup

setmetatable(SpeedPickup, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		return self
	end,
})

function SpeedPickup:create(guid,position,cfi,w,h,d,level,maxTime)
	PickupBase.create(self, guid, position, cfi, w, h, d)
	self.maxTime = maxTime
end

function SpeedPickup:update(elapsedTime)
	if(self.startTimer) then
		self.timeCount = self.timeCount + elapsedTime
		if( self.timeCount>self.maxTime) then
			self.startTimer = false
			self.speedGO.maxMoveSpeed = self.oldMaxMoveSpeed
			logMessage("Ball speed reset")
		end
	end
end

function SpeedPickup:onBeginOverlap(go)
	self.oldMaxMoveSpeed = go.maxMoveSpeed
	go.maxMoveSpeed = 800
	self.speedGO = go
	self.level:manageList(self.guid)
	GameObjectManager:destroyGameObject(self.go)
end

function SpeedPickup:onEndOverlap(go)
	self.timeCount = 0
	self.startTimer = true
end