function createBall()
	
	local ball = GameObjectManager:createGameObject("ball")
	ball.rc = ball:createRenderComponent()
	ball.rc:setPath("data/models/ball.thModel")
	ball.pc = ball:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createSphere(0.5)
	cinfo.motionType = MotionType.Dynamic
	cinfo.mass = 0.4
	cinfo.position = Vec3(0,0,-1)
	cinfo.maxLinearVelocity = 10
	ball.rb = ball.pc:createRigidBody(cinfo)

	ball.update = function (jump)
		
		local vel = ball.rb:getLinearVelocity()
		if(jump) then
			vel.z = vel.z+100
		end
		ball.rb:setLinearVelocity(vel)
		
		local pos = ball.rb:getPosition()
		if(pos.z < -5) then
			ball.rb:setPosition(Vec3(0,0,5))
		end
	end
	
	return ball
end