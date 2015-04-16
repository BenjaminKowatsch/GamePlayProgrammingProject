
include("utils/statemachine.lua")

do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.3)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
end

PhysicsSystem:setDebugDrawingEnabled(true)
ballSpeed = 200
function ballUpdate(guid,deltaTime)
	DebugRenderer:printText(Vec2(-0.2,0.5),"guid "..guid)
	
	local vel = Vec3(0,0,0)
	if(InputHandler:isPressed(Key.Up)) then
		vel.y = vel.y + boxSpeed * deltaTime
	end
	if(InputHandler:isPressed(Key.Down)) then
		vel.y = vel.y -boxSpeed * deltaTime
	end
	if(InputHandler:isPressed(Key.Left)) then
		vel.x = vel.x - boxSpeed * deltaTime
	end
	if(InputHandler:isPressed(Key.Right)) then
		vel.x = vel.x+ boxSpeed * deltaTime
	end	
	
	if(InputHandler:isPressed(Key.W)) then
		vel.z = vel.z - boxSpeed * deltaTime
	end
	if(InputHandler:isPressed(Key.S)) then
		vel.z = vel.z+ boxSpeed * deltaTime
	end
	
	cam.cc:lookAt(ball.rb:getPosition())
	
	box.rb:setLinearVelocity(vel)
end

box = GameObjectManager:createGameObject("box")
box.pc = box:createPhysicsComponent()
cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createBox(Vec3(20,20,0.01))
cinfo.motionType = MotionType.fixed
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
	local pos = ball.rb:getPosition()
	if(pos.z < -5) then
		ball.rb:setPosition(Vec3(0,0,5))
	end
end

Events.Update:registerListener(update)

cam = GameObjectManager:createGameObject("cam")
cam.cc= cam:createCameraComponent()
cam.cc:setPosition(Vec3(0,-5,5))
cam.cc:lookAt(Vec3(0,-2.5,0))
cam.cc:setState(ComponentState.Active)
