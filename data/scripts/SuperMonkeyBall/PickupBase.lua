PickupBase = {}
PickupBase.__index = PickupBase

setmetatable(PickupBase,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	self:_init(...) -- call constructor
	return self
	end,
})
-- define constructor
function PickupBase:_init(guid,position,cfi,w,h,d)
	local go = GameObjectManager:createGameObject(guid)
	go.physics = go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
		cinfo.collisionFilterInfo = cfi
		cinfo.motionType = MotionType.Fixed
		cinfo.position=position
		cinfo.shape = PhysicsFactory:createBox(w,h,d)
		cinfo.isTriggerVolume = true
	go.rigidBody = go.physics:createRigidBody(cinfo)
	go.rigidBody:getTriggerEvent():registerListener(function(args)
		local go = args:getRigidBody():getUserData()
		if args:getEventType() == TriggerEventType.Entered then
			self:onBeginOverlap(go)
		elseif args:getEventType() == TriggerEventType.Left then
			self:onEndOverlap(go)
		end
	end)
	go.rigidBody:setUserData(go)
	self.go = go
end

function PickupBase:onBeginOverlap(go)
	--logMessage("BeginOverlap Base")
end

function PickupBase:onEndOverlap(go)
	--logMessage("EndOverlap Base")
end
