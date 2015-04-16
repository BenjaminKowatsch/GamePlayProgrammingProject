
include("utils/statemachine.lua")

do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.3)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
end

PhysicsSystem:setDebugDrawingEnabled(true)

function boxUpdate(guid,deltaTime)
	DebugRenderer:printText(Vec2(-0.2,0.5),"guid "..guid)
	
	local vel = Vec3(0,0,0)
	
end

box = GameObjectManager:createGameObject("box")
box.pc = box:createPhysicsComponent()
cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createBox(Vec3(2,2,0.1))
cinfo.motionType = MotionType.Keyframed
cinfo.restitution = 0.95
cinfo.position = Vec3(0,0,-4)
box.rb = box.pc:createRigidBody(cinfo)
box.sc = box:createScriptComponent()
box.sc:setUpdateFunction(boxUpdate)

ball = GameObjectManager:createGameObject("ball")
ball.pc = ball:createPhysicsComponent()
cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createSphere(0.5)
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 1.0
cinfo.restitution = 1.0
cinfo.position = Vec3(0,0,-1)
cinfo.maxLinearVelocity = 10
ball.rb = ball.pc:createRigidBody(cinfo)

function update(deltaTime)
	local pos = ball:getPosition()
	if(pos.z < -5) then
		ball:setPosition(Vec3(0,0,5))
	end
end


cam = GameObjectManager:createGameObject("cam")
cam.cc= cam:createCameraComponent()
cam.cc:setPosition(Vec3(0,-5,5))
cam.cc:lookAt(Vec3(0,-2.5,0))
cam.cc:setState(ComponentState.Active)
