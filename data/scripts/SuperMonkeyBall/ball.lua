function createBall()
	
	local ball = GameObjectManager:createGameObject("ball")
	--ball.rc = ball:createRenderComponent()
	--ball.rc:setPath("data/models/ball.thModel")
	ball.pc = ball:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(1)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 2
	cinfo.position = Vec3(0,0,-1)
	cinfo.maxLinearVelocity = 15
	cinfo.restitution = 0.3
	cinfo.linearDamping = 0.5
	cinfo.angularDamping = 0.5
	cinfo.friction = 0.5
	cinfo.rollingFrictionMultiplier = 0.2
	ball.rb = ball.pc:createRigidBody(cinfo)
	--Custom attributes
	ball.maxMoveSpeed = 30
	
	ball.update = function (self,jump,deltaTime,input)
		
		local vel = self.rb:getLinearVelocity()
		
		-- add input to current velocity
		vel = vel:add(Vec3(input.x,input.y,0):mulScalar(self.maxMoveSpeed * deltaTime))
        
		if(jump) then
			vel.z = vel.z+15
		end
		
		self.rb:setLinearVelocity(vel)
		
		local pos = self.rb:getPosition()
		if(pos.z < -8) then
			self.rb:setPosition(Vec3(0,0,5))
		end
	end
	
	ball.calcSteering = function(self, moveVector)
	
		-- calculate the steering direction and amount
		local rightVec = self:getRightDirection()
		local steer = rightVec:dot(moveVector)
		local crossRightMove = rightVec:cross(moveVector)
		if (crossRightMove.z < 0) then
			if (steer < 0) then
				steer = -1
			else
				steer = 1
			end
		end
		return steer
	end	
	
	return ball
end