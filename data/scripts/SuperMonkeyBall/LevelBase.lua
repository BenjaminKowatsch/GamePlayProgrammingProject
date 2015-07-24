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
	cinfo.motionType = MotionType.Keyframed
	cinfo.shape = PhysicsFactory:loadCollisionMesh(cpath)
	--cinfo.shape = PhysicsFactory:createBox(Vec3(398.425,396.85,3.937))
	cinfo.mass = 10
	cinfo.position = position
	cinfo.collisionFilterInfo = 0x1
	go.rb = go.pc:createRigidBody(cinfo)
	go.objectType = "Ground"
	go.rb:setUserData(self)
	go:initialize()
	self.goal = false
	self.go = go
	self.gameObjects = {}
end

function LevelBase:update(elapsedTime)
	for _, go in pairs(self.gameObjects) do
		go:update(elapsedTime)
	end
end

function LevelBase:destroy()
	GameObjectManager:destroyGameObject(self.go)
end



