function createLevel1(position,guid)
	local level = GameObjectManager:createGameObject(guid)
	level.rc = level:createRenderComponent()
	level.rc:setPath("data/models/Map_1.FBX")
	level.pc = level:createPhysicsComponent()
	
	local cinfo = RigidBodyCInfo()
	cinfo.motionType = MotionType.Fixed
	--cinfo.shape = PhysicsFactory:loadCollisionMesh("data/collision/map1.hkx")
	cinfo.shape = PhysicsFactory:createBox(Vec3(398.425,396.85,3.937))
	cinfo.mass = 10
	cinfo.position = position
	cinfo.collisionFilterInfo = 0x1
	
	level.rb = level.pc:createRigidBody(cinfo)

	level.rb:setUserData(level)
	
	return level
end

