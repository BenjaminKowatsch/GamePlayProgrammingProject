function createBox()
	local box = GameObjectManager:createGameObject("box")
	box.pc = box:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(35,35,0.1))
	cinfo.motionType = MotionType.Keyframed
	cinfo.mass = 10
	cinfo.position = Vec3(0,0,-4)
	box.rb = box.pc:createRigidBody(cinfo)
	box.sc = box:createScriptComponent()
	--Custom Attributes
	box.maxAngle = 10
	
	box.update = function (self,deltaTime,input)	
		local AngularVelocity = Vec3(0,0,0)
		
		local boxUp = self:getUpDirection()
		local zyAngle = math.atan(boxUp.y/boxUp.z)*180/math.pi
		local zxAngle = math.atan(boxUp.x/boxUp.z)*180/math.pi
		
		if( input.x > 0	and zxAngle<self.maxAngle )  then
			AngularVelocity.y = 1
		end
		if( input.x < 0	and zxAngle>-self.maxAngle) then
			AngularVelocity.y =-1
		end
		if( input.y < 0	and zyAngle>-self.maxAngle) then
			AngularVelocity.x = 1
		end
		if( input.y > 0	and zyAngle<self.maxAngle) then
			AngularVelocity.x =-1
		end
		
		if (AngularVelocity:squaredLength()~= 0) then
			AngularVelocity = AngularVelocity:normalized()	
			AngularVelocity = AngularVelocity:mulScalar(self.rotationSpeed * deltaTime)
		end

		self.rb:setAngularVelocity(AngularVelocity)

						DebugRenderer:printText(Vec2(0.2,0.4),
								"ZYAngle " ..  zyAngle  .." \n"
								.."ZXAngle " ..  zxAngle  .." \n",
								Color(1,0,0,1))
		
		--box.rb:setLinearVelocity(vel)
	end

	return box
end