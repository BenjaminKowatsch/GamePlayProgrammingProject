PickupBase = {}
PickupBase.__index = PickupBase

setmetatable(PickupBase,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	return self
	end,
})
-- define constructor
function PickupBase:create(guid,position,cfi,w,h,d)
	local go = GameObjectManager:createGameObjectUninitialized(guid)
	go.pc = go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
		cinfo.collisionFilterInfo = cfi
		cinfo.motionType = MotionType.Dynamic
		cinfo.position=position
		cinfo.shape = PhysicsFactory:createBox(w,h,d)
		cinfo.mass = 90
		cinfo.gravityFactor = 30
		cinfo.friction = 8
		cinfo.linearDamping = 2.0
		cinfo.angularDamping = 2.0
		cinfo.rollingFrictionMultiplier = 5
		cinfo.restitution = 1.0
		--cinfo.isTriggerVolume = true
	go.rb = go.pc:createRigidBody(cinfo)
	--go.pc:getContactPointEvent():registerListener(function(event)
	--	local other = event:getBody(CollisionArgsCallbackSource.B)
	--	local self = event:getBody(CollisionArgsCallbackSource.A)
	--	--if other:getUserData():getGuid() == "ball" then
	--	--		logMessage("Pickup COLLISION")
	--	--		GameObjectManager:destroyGameObject(self)
	--	--end
	--	logMessage(tostring(other:getUserData():getGuid()) .. " on Collision")
	--end)
	--go.rb:getTriggerEvent():registerListener(function(args)
	--	local go = args:getRigidBody():getUserData()
	--	if args:getEventType() == TriggerEventType.Entered and go:getGuid() == "ball" then
	--		self:onBeginOverlap(go)
	--	elseif args:getEventType() == TriggerEventType.Left and go:getGuid() == "ball" then
	--		self:onEndOverlap(go)
	--	end
	--end)
	go.rb:setUserData(go)
	go:initialize()
	self.go = go
end

function PickupBase:onBeginOverlap(go)
	--logMessage("BeginOverlap Base")
end

function PickupBase:onEndOverlap(go)
	--logMessage("EndOverlap Base")
end

