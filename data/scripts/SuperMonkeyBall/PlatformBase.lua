PlatformBase = {}
PlatformBase.__index = PlatformBase

setmetatable(PlatformBase,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	self:_init(...) -- call constructor
	return self
	end,
})
-- define constructor
function PlatformBase:_init(guid,position,cfi,w,h,d)
	local go = GameObjectManager:createGameObject(guid)
	go.pc= go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
		cinfo.collisionFilterInfo = cfi
		cinfo.motionType = MotionType.Keyframed
		cinfo.position=position
		cinfo.shape = PhysicsFactory:createBox(w,h,d)
	go.rb = go.pc:createRigidBody(cinfo)
	go.rb:setUserData(go)
	self.go = go
end