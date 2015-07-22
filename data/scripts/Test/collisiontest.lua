include("utils/freecamera.lua")
freeCam.cc:setPosition(Vec3(40, -40, 20))
freeCam.cc:lookAt(Vec3(0, 0, 0))

include("utils/statemachine.lua")

do -- Physics world
    local cinfo = WorldCInfo()
    cinfo.gravity = Vec3(0, 0, -9.81)
    physicsWorld = PhysicsFactory:createWorld(cinfo)
	physicsWorld:setCollisionFilter(PhysicsFactory:createCollisionFilter_Simple())
    PhysicsSystem:setWorld(physicsWorld)
end

PhysicsSystem:setDebugDrawingEnabled(true)

local terrain = GameObjectManager:createGameObject("terrain")
terrain.physicsComponent = terrain:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Fixed
cinfo.shape = PhysicsFactory:loadCollisionMesh("data/collision/terrain.hkx")
cinfo.collisionFilterInfo = 0x1
terrain.rigidBody = terrain.physicsComponent:createRigidBody(cinfo)

local ball = GameObjectManager:createGameObject("ball")
ball.physicsComponent = ball:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Dynamic
cinfo.shape = PhysicsFactory:createSphere(1.0)
cinfo.mass = 1
cinfo.collisionFilterInfo = 0x1
cinfo.position = Vec3(0.0, 9.0, 15.0)
ball.rigidBody = ball.physicsComponent:createRigidBody(cinfo)

local terrain2 = GameObjectManager:createGameObject("terrain2")
terrain2.physicsComponent = terrain2:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Fixed
cinfo.shape = PhysicsFactory:loadCollisionMesh("data/collision/terrain.hkx")
cinfo.collisionFilterInfo = 0x2
cinfo.position = Vec3(0.0, 0.0, 5.0)
terrain2.rigidBody = terrain2.physicsComponent:createRigidBody(cinfo)

local ball2 = GameObjectManager:createGameObject("ball2")
ball2.physicsComponent = ball2:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Dynamic
cinfo.shape = PhysicsFactory:createSphere(1.0)
cinfo.mass = 1
cinfo.collisionFilterInfo = 0x2
cinfo.position = Vec3(0.0, -9.0, 15.0)
ball2.rigidBody = ball2.physicsComponent:createRigidBody(cinfo)
