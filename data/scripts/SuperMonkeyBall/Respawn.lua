function createRespawn(guid,position)
	local respawn = GameObjectManager:createGameObject(guid)
	respawn.pc = respawn:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	respawn.fallOut = false
	respawn.initPosition = position
	cinfo.collisionFilterInfo = 0x1
	cinfo.motionType = MotionType.Keyframed
	cinfo.position=position
	cinfo.shape = PhysicsFactory:createBox(2000,2000,15)
	cinfo.isTriggerVolume = true
	respawn.rb = respawn.pc:createRigidBody(cinfo)
	respawn.rb:getTriggerEvent():registerListener(function(args)
		-- not used anymore!
 		--local gameo = args:getRigidBody():getUserData()
		logMessage("test ".. respawn:getGuid())
 		if args:getEventType() == TriggerEventType.Entered then
 			respawn.onBeginOverlap()
 		end
 	end)
	


respawn.onBeginOverlap = function ()
	logMessage("TOT")
	respawn.fallOut = true
end
	respawn.objectType = "Respawn"
	respawn.go = respawn
	respawn.rb:setUserData(respawn)	
	return respawn
end