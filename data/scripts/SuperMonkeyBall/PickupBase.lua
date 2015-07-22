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
	go.pc = go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
		cinfo.collisionFilterInfo = cfi
		cinfo.motionType = MotionType.Dynamic
		cinfo.position=position
		cinfo.mass = 10
		cinfo.shape = PhysicsFactory:createBox(w,h,d)
		cinfo.isTriggerVolume = true
	go.rb = go.pc:createRigidBody(cinfo)
	go.rb:getTriggerEvent():registerListener(function(args)
		local go = args:getRigidBody():getUserData()
		if args:getEventType() == TriggerEventType.Entered and go:getGuid() == "ball" then
			self:onBeginOverlap(go)
		elseif args:getEventType() == TriggerEventType.Left and go:getGuid() == "ball" then
			self:onEndOverlap(go)
		end
	end)
	go.rb:setUserData(go)
	self.go = go
end

function PickupBase:onBeginOverlap(go)
	--logMessage("BeginOverlap Base")
end

function PickupBase:onEndOverlap(go)
	--logMessage("EndOverlap Base")
end

