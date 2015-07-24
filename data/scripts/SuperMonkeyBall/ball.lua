function createBall(position)
	local ball = GameObjectManager:createGameObject("ball")
	ball.rc = ball:createRenderComponent()
	ball.rc:setPath("data/models/monkey/monkey.FBX")
	ball.rc:setScale(Vec3(0.7,0.7,0.7))
	ball.pc = ball:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	--cinfo.shape = PhysicsFactory:createSphere(11.181)
	cinfo.shape = PhysicsFactory:createSphere(8.181)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 20
	cinfo.position = position
	cinfo.maxLinearVelocity = 280
	cinfo.restitution = 0.7
	cinfo.linearDamping = 1.0
	cinfo.angularDamping = 1.0
	cinfo.friction = 0.8
	cinfo.gravityFactor = 30.0
	cinfo.rollingFrictionMultiplier = 0.8
	cinfo.collisionFilterInfo = 0x1
	ball.rb = ball.pc:createRigidBody(cinfo)
	--Custom attributes
	ball.initPosition = position
	ball.coinCount = 0
	ball.maxMoveSpeed = 180
	ball.maxJumpCount = 1
	ball.jumping = false
	ball.jumpCount = 1
	ball.jumpHeight = 100
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
	
	ball.increaseSpeed = function(self,maxTime)
		self.timerCount = 0
		self.maxTime = maxTime
		if( self.speedTimer == false) then
			self.speedTimer = true
			local c = self.maxMoveSpeed
			self.maxMoveSpeed = self.speedPickupSpeed
			self.speedPickupSpeed = c
		end
		logMessage("Increased speed")
	end
	
	ball.resetSpeed = function(self)
		if(self.speedTimer) then
				self.timerCount = 0
				self.speedTimer = false
				local c = self.maxMoveSpeed
				self.maxMoveSpeed = self.speedPickupSpeed
				self.speedPickupSpeed = c
				logMessage("Reset speed")
		end
	end
	
	ball.enableDoubleJump = function(self)
		logMessage("DoubleJump enabled")
		self.maxJumpCount = 2
	end
	
	ball.disableDoubleJump = function(self)
		logMessage("DoubleJump disabled")
		self.maxJumpCount = 1
	end
	
	ball.reset = function(self)
		gravityFactor = -1
		self:disableDoubleJump()
		self:resetSpeed()
		self.rb:setPosition(self.initPosition)
		self.rb:setLinearVelocity(Vec3(0,0,0))	
	end
	
	ball.jump = function(self)
		if self.jumpCount<self.maxJumpCount then
			logMessage("Jump ".. self.jumpCount)
			self.jumping = true
			self.jumpCount = self.jumpCount +1
			if self.jumpCount == self.maxJumpCount then
				self:disableDoubleJump()
			end
		end		
	end		
	
	ball.update = function (self,elapsedTime,input)
		local vel = self.rb:getLinearVelocity()
		
		-- add input to current velocity
		vel = vel:add(Vec3(input.x,input.y,0):mulScalar(self.maxMoveSpeed * elapsedTime))
			
		self.timerCount = self.timerCount + elapsedTime
		if( self.timerCount>self.maxTime) then
			self:resetSpeed()
		end
		
		if(self.jumping)then
			vel.z = vel.z+self.jumpHeight*-gravityFactor
			self.jumping = false
		end
		self.rb:setLinearVelocity(vel)
	end
	
	ball.rb:setUserData(ball)
	
	return ball
end