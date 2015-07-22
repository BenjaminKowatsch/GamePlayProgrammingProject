Level = {}
Level.__index = Level

setmetatable(Level,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	self:_init(...) -- call constructor
	return self
	end,
})


-- define constructor
function Level:_init(guid, position, mpath, cpath)
	local go = GameObjectManager:createGameObject(guid)
	go.rc = go:createRenderComponent()
	go.rc:setPath(mpath)
	go.pc = go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.motionType = MotionType.Fixed
	cinfo.shape = PhysicsFactory:loadCollisionMesh(cpath)
	--cinfo.shape = PhysicsFactory:createBox(Vec3(398.425,396.85,3.937))
	cinfo.mass = 10
	cinfo.position = position
	cinfo.collisionFilterInfo = 0x1
	go.rb = go.pc:createRigidBody(cinfo)

	go.rb:setUserData(go)
	self.goal = false
	self.map = go
end

function Level:setComponentStates(state)
	self.map.setComponentStates(state)
end



