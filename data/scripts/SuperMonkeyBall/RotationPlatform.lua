RotationPlatform = {}
RotationPlatform.__index = RotationPlatform

setmetatable(RotationPlatform,{
	__index = PlatformBase,
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	return self
	end,
})

function RotationPlatform:create(guid,position,cfi,size,rotSpeed,maxAngle,rcpath)
	PlatformBase.create(self,guid,position,cfi,size,rcpath)
	self.angle = 0
	self.rotSpeed = rotSpeed
	self.maxAngle = maxAngle
end
-- update
function RotationPlatform:update(elapsedTime)
		local m = self.go.rb:getRotation():toMat3()
		local angle = angleBetweenVec2(Vec2(1,0),Vec2(m.m00,m.m10))
		if(angle>self.maxAngle or angle <-self.maxAngle) then
			logMessage("Angle Changed")
			self.rotSpeed = -self.rotSpeed
		end
		--self.angle = self.angle + self.rotSpeed*elapsedTime	
		--local z = Quaternion(Vec3(0.0, 0.0, 1.0), self.angle)
		--self.go.rb:setRotation(z)
		--logMessage("Rotation: ".. angleBetweenVec2(Vec2(1,0),Vec2(m.m00,m.m10))
				--m.m00.." ".. m.m01.." ".. m.m02.." ".. m.m10.." ".. m.m11.." ".. m.m12.." ".. m.m20.." ".. m.m21.." ".. m.m22.." "
		--	)
		--self.go.rb:setAngularVelocity(Vec3(0.0, 0.0, ((self.rotSpeed*math.pi)/180)*elapsedTime*self.rotSpeedFactor)) 
		self.go.rb:setAngularVelocity(Vec3(0.0, 0.0,self.rotSpeed*elapsedTime)) 
end