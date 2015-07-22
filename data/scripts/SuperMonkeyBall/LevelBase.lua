LevelBase = {}
LevelBase.__index = LevelBase

setmetatable(LevelBase,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	return self
	end,
})


-- define constructor
function LevelBase:create(guid, position, mpath, cpath)
	local go = GameObjectManager:createGameObjectUninitialized(guid)
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
	go:initialize()
	self.goal = false
	self.map = go
end

function LevelBase:setComponentStates(state)
	self.map.setComponentStates(state)
end



