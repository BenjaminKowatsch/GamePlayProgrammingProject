function createPickup()
	local pickup = GameObjectManager:createGameObject("pickup")
	pickup.physics = pickup:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
		cinfo.collisionFilterInfo = 0x1
		cinfo.motionType = MotionType.Fixed
		cinfo.position=Vec3(30,0,0)
		cinfo.shape = PhysicsFactory:createBox(15,15,15) -- 1 meter
		cinfo.isTriggerVolume = true -- Don't forget this! ;)
	pickup.rigidBody = pickup.physics:createRigidBody(cinfo)
	pickup.rigidBody:getTriggerEvent():registerListener(function(args)
		local go = args:getRigidBody():getUserData()
		if args:getEventType() == TriggerEventType.Entered then
			go.maxJumpCount = 2
		elseif args:getEventType() == TriggerEventType.Left then
			logMessage(go:getGuid() .. " left the trigger.")
    end
	end)
	pickup.rigidBody:setUserData(pickup)
	return pickup
end