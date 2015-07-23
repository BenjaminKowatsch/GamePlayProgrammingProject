PickupBase = {}
PickupBase.__index = PickupBase

setmetatable(PickupBase,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	return self
	end,
})
-- define constructor
function PickupBase:create(guid,position,cfi,w,h,d,level,rcpath)
	local go = GameObjectManager:createGameObjectUninitialized(guid)
	go.rc = go:createRenderComponent()
	go.rc:setPath(rcpath)
	go.pc = go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
		cinfo.collisionFilterInfo = cfi
		cinfo.motionType = MotionType.Keyframed
		cinfo.position=position
		cinfo.shape = PhysicsFactory:createBox(w,h,d)
		cinfo.isTriggerVolume = true
	go.rb = go.pc:createRigidBody(cinfo)
	go.rb:getTriggerEvent():registerListener(function(args)
 		local go = args:getRigidBody():getUserData()
 		if args:getEventType() == TriggerEventType.Entered then
 			self:onBeginOverlap(go)
 		end
 	end)
	go.objectType = "Pickup"
	go.rb:setUserData(self)
	go:initialize()
	self.go = go
end

function PickupBase:update(elapsedTime)
end

function PickupBase:onBeginOverlap(go)
	--logMessage("BeginOverlap Base")
end


