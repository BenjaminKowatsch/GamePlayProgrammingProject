PickupBaseTest = {}
PickupBaseTest.__index = PickupBaseTest

setmetatable(PickupBaseTest,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	self._init(...)
	return self
	end,
})
-- define constructor

function PickupBaseTest:_init()

end
function PickupBaseTest:create(guid,position,cfi,w,h,d)
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

function PickupBaseTest:onBeginOverlap(go)
	--logMessage("BeginOverlap Base")
end

function PickupBaseTest:onEndOverlap(go)
	--logMessage("EndOverlap Base")
end

PickupBaseTestChild = {}
PickupBaseTestChild.__index = PickupBaseTestChild

setmetatable(PickupBaseTestChild,{
	__index = PickupBaseTest,
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	self._init(...)
	return self
	end,
})
-- define constructor
function PickupBaseTestChild:_init()
	PickupBaseTest._init(self)
end

function PickupBaseTestChild:create(guid,position,cfi,w,h,d)
	PickupBaseTest.create(guid,position,cfi,w,h,d)
end

function PickupBaseTestChild:onBeginOverlap(go)
	--logMessage("BeginOverlap Base")
end

function PickupBaseTestChild:onEndOverlap(go)
	--logMessage("EndOverlap Base")
end

test = PickupBaseTestChild()
test:create("Hallo", Vec3(0,0,14),0x1,10,10,10,10)