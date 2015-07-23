function createBall()
	
	local ball = GameObjectManager:createGameObject("ball")
	--ball.rc = ball:createRenderComponent()
	--ball.rc:setPath("data/models/Sphere/Sphere.FBX")
	ball.pc = ball:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	--cinfo.shape = PhysicsFactory:createSphere(11.181)
	cinfo.shape = PhysicsFactory:createSphere(8.181)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 20
	cinfo.position = Vec3(0,0,18)
	cinfo.maxLinearVelocity = 280
	cinfo.restitution = 0.5
	cinfo.linearDamping = 1.0
	cinfo.angularDamping = 1.0
	cinfo.friction = 0.8
	cinfo.gravityFactor = 30.0
	cinfo.rollingFrictionMultiplier = 0.8
	cinfo.collisionFilterInfo = 0x1
	ball.rb = ball.pc:createRigidBody(cinfo)
	--Custom attributes
	ball.coinCount = 0
	ball.maxMoveSpeed = 180
	ball.maxJumpCount = 1
	ball.jumping = false
	ball.jumpCount = 1
	-- Speed Pickup
	ball.speedTimer = false
	ball.speedPickupSpeed = 500
	ball.timerCount = 0
	ball.maxTime = 0
	ball.pc:getContactPointEvent():registerListener(function(event)
		local other = event:getBody(CollisionArgsCallbackSource.B)
		local self = event:getBody(CollisionArgsCallbackSource.A)
		--if other:getUserData().go.objectType == "Pickup" then
		--	other:getUserData():onBeginOverlap(self:getUserData())
		--elseif other:getUserData().go.objectType == "Ground" then
		--	ball.jumpCount = ball.maxJumpCount
		--end
		if other:getUserData().go.objectType == "Ground" then
			ball.jumpCount = 0
		end
		
	end)
	ball.jump = function()
	logMessage(" jumpCount ".. ball.jumpCount )

		if ball.jumpCount<ball.maxJumpCount then
			ball.jumping = true
			ball.jumpCount = ball.jumpCount +1

			if ball.jumpCount == ball.maxJumpCount then
				ball.maxJumpCount = 1
			end
		end		
	end		
	
	ball.update = function (self,elapsedTime,input)
		local vel = self.rb:getLinearVelocity()
		
		-- add input to current velocity
		vel = vel:add(Vec3(input.x,input.y,0):mulScalar(self.maxMoveSpeed * elapsedTime))
		
		if(self.speedTimer) then
			self.timerCount = self.timerCount + elapsedTime
			if( self.timerCount>self.maxTime) then
				self.speedTimer = false
				local c = self.maxMoveSpeed
				self.maxMoveSpeed = self.speedPickupSpeed
				self.speedPickupSpeed = c
				logMessage("Ball speed reset")
			end
		end
		
		if(self.jumping)then
			vel.z = vel.z+95*-gravityFactor
			self.jumping = false
		end
		self.rb:setLinearVelocity(vel)
	end
	
	ball.rb:setUserData(ball) -- Always a good idea
	
	return ball
end