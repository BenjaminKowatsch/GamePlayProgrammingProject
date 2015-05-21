function createBall()
	
	local ball = GameObjectManager:createGameObject("ball")
	--ball.rc = ball:createRenderComponent()
	--ball.rc:setPath("data/models/ball.thModel")
	ball.pc = ball:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(0.5)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 1
	cinfo.position = Vec3(0,0,-1)
	cinfo.maxLinearVelocity = 10
	cinfo.restitution = 0.0
	cinfo.rollingFrictionMultiplier = 0.2
	ball.rb = ball.pc:createRigidBody(cinfo)

	ball.update = function (self,jump,deltaTime,input)
		
		local vel = self.rb:getLinearVelocity()
		
		--local lv = Vec3(input.x,input.y,0)
		--if (lv:squaredLength()~= 0) then
		--	lv = lv:normalized()	
		--	lv = lv:mulScalar(self.moveSpeed * deltaTime)
		--end
		--vel = vel:add(lv)

		if(jump) then
			vel.z = vel.z+100
		end
		
		self.rb:setLinearVelocity(vel)
		
		local pos = self.rb:getPosition()
		if(pos.z < -8) then
			self.rb:setPosition(Vec3(0,0,5))
		end
	end
	
	return ball
end