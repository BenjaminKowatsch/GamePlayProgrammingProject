function createBall()
	
	local ball = GameObjectManager:createGameObject("ball")
	--ball.rc = ball:createRenderComponent()
	--ball.rc:setPath("data/models/monkey/monkey.FBX")
	ball.pc = ball:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(11.181)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 20
	cinfo.position = Vec3(0,0,18)
	cinfo.maxLinearVelocity = 280
	cinfo.restitution = 0.0 --no bounciness
	cinfo.linearDamping = 1.0
	cinfo.angularDamping = 1.0
	cinfo.friction = 1.0
	cinfo.gravityFactor = 20.0
	cinfo.rollingFrictionMultiplier = 1.0
	ball.rb = ball.pc:createRigidBody(cinfo)
	--Custom attributes
	ball.maxMoveSpeed = 280
	ball.update = function (self,jump,deltaTime,input)
	
		local vel = self.rb:getLinearVelocity()
		
		-- add input to current velocity
		vel = vel:add(Vec3(input.x,input.y,0):mulScalar(self.maxMoveSpeed * deltaTime))
		
		if(jump)then
			vel.z = vel.z+150
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