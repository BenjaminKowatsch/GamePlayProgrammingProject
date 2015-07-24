function createRespawn()
	local respawn = GameObjectManager:createGameObject("respawn")
	respawn.pc = respawn:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	respawn.goal = false
	cinfo.collisionFilterInfo = 0x1
	cinfo.motionType = MotionType.Keyframed
	cinfo.position=Vec3(0,0,-300)
	cinfo.shape = PhysicsFactory:createBox(2000,2000,15)
	cinfo.isTriggerVolume = true
	--respawn.objectType = "Respawn"
	respawn.rb = respawn.pc:createRigidBody(cinfo)
	respawn.rb:getTriggerEvent():registerListener(function(args)
 		local gameo = args:getRigidBody():getUserData()
 		if args:getEventType() == TriggerEventType.Entered then
 			respawn.onBeginOverlap()
 		end
 	end)
	


respawn.onBeginOverlap = function ()
	logMessage("TOT")
	respawn.goal = true
end

	respawn.go = respawn
	respawn.rb:setUserData(respawn)
	return respawn
end