function createBall()
	
	local ball = GameObjectManager:createGameObject("ball")
	ball.rc = ball:createRenderComponent()
	ball.rc:setPath("data/models/Sphere/Sphere.FBX")
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
	cinfo.friction = 0.8
	cinfo.gravityFactor = 30.0
	cinfo.rollingFrictionMultiplier = 0.8
	cinfo.collisionFilterInfo = 0x1
	ball.rb = ball.pc:createRigidBody(cinfo)
	--Custom attributes
	ball.coinCount = 0
	ball.maxMoveSpeed = 400
	ball.maxJumpCount = 1
	ball.jumping = false
	ball.jumpCount = 1
	ball.pc:getContactPointEvent():registerListener(function(event)
		logMessage("COLLISION")
		local other = event:getBody(CollisionArgsCallbackSource.B)
		local self = event:getBody(CollisionArgsCallbackSource.A)
		if other:getUserData():getGuid() == "level1" or other:getUserData():getGuid() == "box1" then
			ball.jumpCount = ball.maxJumpCount
		end
		--logMessage(tostring(other:getUserData():getGuid()) .. " on Collision")
	end)
	ball.jump =function()
	logMessage(" jumpCount ".. ball.jumpCount )
		if 0<ball.jumpCount then
			ball.jumping = true
			ball.jumpCount = ball.jumpCount -1 
		end		
	end	
	
	ball.update = function (self,deltaTime,input)
		local vel = self.rb:getLinearVelocity()
		
		-- add input to current velocity
		vel = vel:add(Vec3(input.x,input.y,0):mulScalar(self.maxMoveSpeed * deltaTime))
		
		if(self.jumping)then
			vel.z = vel.z+180*-gravityFactor
			self.jumping = false
		end
		self.rb:setLinearVelocity(vel)
	end	
	ball.rb:setUserData(ball) -- Always a good idea
	
	return ball
end