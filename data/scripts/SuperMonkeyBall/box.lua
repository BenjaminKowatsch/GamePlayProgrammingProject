function createBox()
	local box = GameObjectManager:createGameObject("box")
	box.pc = box:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createBox(Vec3(15,15,0.1))
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 10
	cinfo.rollingFrictionMultiplier = 0.1
	cinfo.linearDamping = 0.1
	cinfo.angularDamping = 0.1
	cinfo.restitution = 0.8
	cinfo.friction = 0.5
	cinfo.position = Vec3(0,0,-4)
	box.rb = box.pc:createRigidBody(cinfo)
	box.sc = box:createScriptComponent()
	-- Custom attributes
	box.cAV = Vec3(0,0,0) -- cumulated AngularVelocity
	
	box.update = function (self,deltaTime,input)	
		local AngularVelocity = Vec3(0,0,0)
		
		if( input.x > 0	and self.cAV:mulScalar(deltaTime*180/math.pi).y < self.maxAngle )  then
			AngularVelocity.y = 1
		end
		if( input.x < 0	and self.cAV:mulScalar(deltaTime*180/math.pi).y > -self.maxAngle) then
			AngularVelocity.y =-1
		end
		if( input.y < 0	and self.cAV:mulScalar(deltaTime*180/math.pi).x < self.maxAngle) then
			AngularVelocity.x = 1
		end
		if( input.y > 0	and self.cAV:mulScalar(deltaTime*180/math.pi).x > -self.maxAngle) then
			AngularVelocity.x =-1
		end
		
		if (AngularVelocity:squaredLength()~= 0) then
			AngularVelocity = AngularVelocity:normalized()	
			AngularVelocity = AngularVelocity:mulScalar(self.rotationSpeed * deltaTime)
		end
		
		self.cAV = self.cAV:add(AngularVelocity)
		self.rb:setAngularVelocity(AngularVelocity)
		
		DebugRenderer:printText(Vec2(0.2,0.4),
								"AngularVelocity " .." ".. self.cAV:mulScalar(deltaTime*180/math.pi).x .." ".. self.cAV:mulScalar(deltaTime*180/math.pi).y .." ".. self.cAV:mulScalar(deltaTime*180/math.pi).z ,
								Color(1,0,0,1))
		
		--box.rb:setLinearVelocity(vel)
	end

	return box
end