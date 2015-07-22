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
		cinfo.motionType = MotionType.Fixed
		cinfo.position=position
		cinfo.shape = PhysicsFactory:createBox(w,h,d)
		cinfo.isTriggerVolume = true
	go.rb = go.pc:createRigidBody(cinfo)
	go.rb:getTriggerEvent():registerListener(function(args)
		local go = args:getRigidBody():getUserData()
		if args:getEventType() == TriggerEventType.Entered then
			self:onBeginOverlap(go)
		elseif args:getEventType() == TriggerEventType.Left then
			self:onEndOverlap(go)
		end
	end)
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

