MovingPlatform = {}
MovingPlatform.__index = MovingPlatform

setmetatable(MovingPlatform,{
	__index = PlatformBase,
	__call = function(cls, ...)
		local self = setmetatable({}, cls)
		return self
	end,
})

-- create game object
function MovingPlatform:create(guid,position,cfi,size,moveSpeed,dest,rcpath)
	PlatformBase.create(self,guid,position,cfi,size,rcpath)
	self.start = position
	self.moveVec = (dest-position):normalized()
	self.moveSpeed = moveSpeed
	self.dest = dest
end
-- update
function MovingPlatform:update(elapsedTime)
		local a = self.go.rb:getPosition()-self.dest
		local b = self.go.rb:getPosition()-self.start
		if( (a.x*b.x+a.y*b.y+a.z*b.z)>0)  then
			logMessage("Direction changed")
			self.moveVec = self.moveVec:mulScalar(-1)
		end
		self.go.rb:setLinearVelocity(self.moveVec:mulScalar(elapsedTime*self.moveSpeed))
end