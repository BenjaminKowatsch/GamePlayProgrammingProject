include("utils/freecamera.lua")
include("utils/statemachine.lua")
do -- Physics world
    local cinfo = WorldCInfo()
    cinfo.gravity = Vec3(0, 0, -9.81)
    physicsWorld = PhysicsFactory:createWorld(cinfo)
	physicsWorld:setCollisionFilter(PhysicsFactory:createCollisionFilter_Simple())
    PhysicsSystem:setWorld(physicsWorld)
end
-- Make sure we will see the terrain
PhysicsSystem:setDebugDrawingEnabled(true)
local terrain = GameObjectManager:createGameObject("terrain")
-- The part above is from the "importing render geometry" guide
terrain.rc = terrain:createRenderComponent()
terrain.rc:setPath("data/models/Level1.FBX")
-- Create a physics component
terrain.physicsComponent = terrain:createPhysicsComponent()
-- Create a rigid body using our externally created collision mesh
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Fixed -- The terrain is fixed (static), of course
cinfo.shape = PhysicsFactory:loadCollisionMesh("data/collision/terrain.hkx")
cinfo.collisionFilterInfo = 0x1
terrain.rigidBody = terrain.physicsComponent:createRigidBody(cinfo)
local ball = GameObjectManager:createGameObject("ball")
ball.physicsComponent = ball:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Dynamic
cinfo.shape = PhysicsFactory:createSphere(11.181) -- 1x1x1 meters
cinfo.mass = 1
cinfo.gravityFactor = 0
cinfo.collisionFilterInfo = 0x1
cinfo.position = Vec3(0.0, 9.0, 13.0) -- Spawn the ball somewhere on the slope
ball.rigidBody = ball.physicsComponent:createRigidBody(cinfo)