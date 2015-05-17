
include("utils/statemachine.lua")

do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.3)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)
end

boxSpeed = 400
rotationSpeed = 40
maxAngle = 10
function boxUpdate(guid,deltaTime)	
	local AngularVelocity = Vec3(0,0,0)
	
	local gamepad = InputHandler:gamepad(0)
	local leftStick = gamepad:leftStick()
	
	DebugRenderer:printText(Vec2(-0.2,0.5),"LeftStickInput "..leftStick.x .. " " ..leftStick.y .. " " .. leftStick:length())
	
	if( ( leftStick.x >0 or InputHandler:isPressed(Key.Right))
		and box.cAV:mulScalar(deltaTime*180/math.pi).y < maxAngle )  then
		AngularVelocity.y = 1
	end
	if( ( leftStick.x <0 or InputHandler:isPressed(Key.Left)) 
		and box.cAV:mulScalar(deltaTime*180/math.pi).y > -maxAngle) then
		AngularVelocity.y =-1
	end
	if( ( leftStick.y <0 or InputHandler:isPressed(Key.Down)) 
		and box.cAV:mulScalar(deltaTime*180/math.pi).x < maxAngle) then
		AngularVelocity.x = 1
	end
	if( ( leftStick.y >0 or InputHandler:isPressed(Key.Up)) 
		and box.cAV:mulScalar(deltaTime*180/math.pi).x > -maxAngle) then
		AngularVelocity.x =-1
	end
	
	if (AngularVelocity:squaredLength()~= 0) then
		AngularVelocity = AngularVelocity:normalized()	
		AngularVelocity = AngularVelocity:mulScalar(rotationSpeed * deltaTime)
	end
	
	box.cAV = box.cAV:add(AngularVelocity)
	box.rb:setAngularVelocity(AngularVelocity)
	
	DebugRenderer:printText(Vec2(0.2,0.4),
							"AngularVelocity " .." ".. box.cAV:mulScalar(deltaTime*180/math.pi).x .." ".. box.cAV:mulScalar(deltaTime*180/math.pi).y .." ".. box.cAV:mulScalar(deltaTime*180/math.pi).z ,
							Color(1,0,0,1))
	
	cam.cc:setPosition(ball:getWorldPosition():add(Vec3(0,-10,5)))
	cam.cc:setViewTarget(ball)
	
	--box.rb:setLinearVelocity(vel)
end

box = GameObjectManager:createGameObject("box")
box.pc = box:createPhysicsComponent()
cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createBox(Vec3(15,15,0.1))
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 10
cinfo.rollingFrictionMultiplier = 0.1
cinfo.linearDamping = 0.1
cinfo.angularDamping = 0.1
cinfo.restitution = 0.8
cinfo.friction = 0.5
cinfo.position = Vec3(0,0,-4)
box.rb = box.pc:createRigidBody(cinfo)
box.sc = box:createScriptComponent()
box.sc:setUpdateFunction(boxUpdate)
-- Custom attributes
box.cAV = Vec3(0,0,0) -- cumulated AngularVelocity


ball = GameObjectManager:createGameObject("ball")
ball.pc = ball:createPhysicsComponent()
cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createSphere(0.5)
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 0.4
cinfo.position = Vec3(0,0,-1)
cinfo.maxLinearVelocity = 10
ball.rb = ball.pc:createRigidBody(cinfo)

function ballUpdate(deltaTime)
	
	local vel = ball.rb:getLinearVelocity()
	if(InputHandler:wasTriggered(Key.Space) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.A)) then
		vel.z = vel.z+100
	end
	ball.rb:setLinearVelocity(vel)
	
	local pos = ball.rb:getPosition()
	if(pos.z < -5) then
		ball.rb:setPosition(Vec3(0,0,5))
	end
end

Events.Update:registerListener(ballUpdate)

cam = GameObjectManager:createGameObject("cam")
cam.cc= cam:createCameraComponent()
cam.cc:setPosition(Vec3(0,-5,5))
cam.cc:lookAt(Vec3(0,-2.5,0))
cam.cc:setState(ComponentState.Active)

Events.PostInitialization:registerListener(function()

local cinfo = {
    type = ConstraintType.BallAndSocket, -- The constraint type
    A = box.rb,                   -- Take care not to use the game object but its rigid body!
    B = nil,                -- If you omit this one (or set it to nil), the physics world itself is used as B
    constraintSpace = "world", -- Wether the given pivot or pivots are in world or in local (body) space
    -- Only required if constraintSpace == "world"
    pivot = box:getWorldPosition(), -- Global coordinates
}
local constraint = PhysicsFactory:createConstraint(cinfo)
PhysicsSystem:getWorld():addConstraint(constraint) -- 'world' must have been created earlier at some point, of course

end)