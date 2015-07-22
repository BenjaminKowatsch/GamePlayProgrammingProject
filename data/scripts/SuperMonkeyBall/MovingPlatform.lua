MovingPlatform = {}
MovingPlatform.__index = MovingPlatform

setmetatable(MovingPlatform,{
	__index = PlatformBase,
	__call = function(cls, ...)
		local self = setmetatable({}, cls)
		return self
	end,
})
function MovingPlatform:create(guid,position,cfi,w,h,d,moveSpeed,dest)
	PlatformBase.create(self,guid,position,cfi,w,h,d)
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
		self.moveVec = self.moveVec:mulScalar(-1)
	end
	--self.go.rb:applyLinearImpulse(self.moveVec:mulScalar(elapsedTime*500))
	self.go.rb:setLinearVelocity(self.moveVec:mulScalar(elapsedTime*self.moveSpeed))
	--self.go.rb:setPosition(self.go.rb:getPosition()+self.moveVec:mulScalar(elapsedTime))
end