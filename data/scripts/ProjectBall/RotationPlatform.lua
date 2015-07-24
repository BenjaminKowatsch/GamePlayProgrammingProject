RotationPlatform = {}
RotationPlatform.__index = RotationPlatform

setmetatable(RotationPlatform,{
	__index = PlatformBase,
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	return self
	end,
})
-- create game object
function RotationPlatform:create(guid,position,cfi,size,rotSpeed,maxAngle,rcpath,initRot)
	PlatformBase.create(self,guid,position,cfi,size,rcpath)
	self.angle = 0
	self.initRot = initRot
	self.go:setRotation(Quaternion(Vec3(0,0,1),initRot))
	self.rotSpeed = rotSpeed
	self.maxAngle = maxAngle
end
-- update
function RotationPlatform:update(elapsedTime)
		local m = self.go.rb:getRotation():toMat3()
		local angle = angleBetweenVec2(Vec2(1,0),Vec2(m.m00,m.m10))-self.initRot
		if(angle>self.maxAngle or angle <-self.maxAngle) then
			logMessage("Angle changed")
			self.rotSpeed = -self.rotSpeed
		end
		self.go.rb:setAngularVelocity(Vec3(0.0, 0.0,self.rotSpeed*elapsedTime)) 
end