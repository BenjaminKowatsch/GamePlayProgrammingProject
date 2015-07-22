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

function SpeedPickup:_init(guid,position,cfi,w,h,d,maxTime)
	PickupBase._init(self,guid,position,cfi,w,h,d) -- super constructor call 
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
end

function SpeedPickup:onEndOverlap(go)
	self.timeCount = 0
	self.startTimer = true
end