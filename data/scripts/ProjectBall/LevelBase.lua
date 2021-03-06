LevelBase = {}
LevelBase.__index = LevelBase

setmetatable(LevelBase,{
	__call = function(cls, ...)
	local self = setmetatable({}, cls)
	return self
	end,
})
-- create game object
function LevelBase:create(guid, position, mpath, cpath)
	local go = GameObjectManager:createGameObjectUninitialized(guid)
	go.rc = go:createRenderComponent()
	go.rc:setPath(mpath)
	go.pc = go:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.motionType = MotionType.Keyframed
	cinfo.shape = PhysicsFactory:loadCollisionMesh(cpath)
	cinfo.mass = 10
	cinfo.position = position
	cinfo.collisionFilterInfo = 0x1
	go.rb = go.pc:createRigidBody(cinfo)
	go.objectType = "Ground"
	go.rb:setUserData(self)
	go:initialize()
	self.go = go
	self.gameObjects = {}
end

function LevelBase:update(elapsedTime)
	for _, go in pairs(self.gameObjects) do
		go:update(elapsedTime)
	end
end

function LevelBase:manageList(guid)
	self.gameObjects[guid]=nil
end

function LevelBase:destroy()
	GameObjectManager:destroyGameObject(self.go)
	for _, go in pairs(self.gameObjects) do
		GameObjectManager:destroyGameObject(go.go)
	end
end



