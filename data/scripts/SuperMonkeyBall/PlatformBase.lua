PlatformBase = {}
PlatformBase.__index = PlatformBase

setmetatable(PlatformBase,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	return self
	end,
})

-- define constructor
function PlatformBase:create(guid,position,cfi,size,rcpath)
	local go = GameObjectManager:createGameObjectUninitialized(guid)
	go.rc = go:createRenderComponent()
	go.rc:setPath(rcpath)
	go.pc= go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
		cinfo.collisionFilterInfo = cfi
		cinfo.motionType = MotionType.Keyframed
		cinfo.position=position
		cinfo.shape = PhysicsFactory:createBox(size.x,size.y,size.z)
	go.rb = go.pc:createRigidBody(cinfo)
	go.objectType = "Ground"
	go.rb:setUserData(self)
	go:initialize()
	self.go = go
end

function PlatformBase:update(elapsedTime)
end