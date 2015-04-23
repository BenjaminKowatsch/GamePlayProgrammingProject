
include("utils/statemachine.lua")

do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.3)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
end

PhysicsSystem:setDebugDrawingEnabled(true)
boxSpeed = 400
yAngle = 0
xAngle = 0
function boxUpdate(guid,deltaTime)
	DebugRenderer:printText(Vec2(-0.2,0.5),"guid "..guid)
	--[[
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
	]]--
	if(InputHandler:isPressed(Key.Right)) then
		--box:setRotation(QuaternionFromEuler(0,yAngle,0))
		box.rb:applyAngularImpulse(Vec3(0,yAngle,0))
		yAngle = yAngle + 60*deltaTime
	end
	if(InputHandler:isPressed(Key.Left)) then
		box:setRotation(QuaternionFromEuler(0,yAngle,0))
		box.rb:applyAngularImpulse(Vec3(0,yAngle,0))
		yAngle = yAngle - 60*deltaTime
	end
	if(InputHandler:isPressed(Key.Down)) then
		box:setRotation(QuaternionFromEuler(xAngle,0,0))
		box.rb:applyAngularImpulse(Vec3(0,yAngle,0))
		xAngle = xAngle + 60*deltaTime
	end
	if(InputHandler:isPressed(Key.Up)) then
		box:setRotation(QuaternionFromEuler(xAngle,0,0))
		box.rb:applyAngularImpulse(Vec3(0,yAngle,0))
		xAngle = xAngle - 60*deltaTime
	end
	
	cam.cc:setPosition(ball:getWorldPosition():add(Vec3(0,-10,5)))
	cam.cc:setViewTarget(ball)
	local rotation = EulerFromQuaternion(box:getRotation())
	DebugRenderer:printText(Vec2(0.1,0.1),
							"Rotation: x:" .. rotation.x .. " y:" .. rotation.y .. " z:" .. rotation.z,
							Color(1,0,0,1))
	
	--box.rb:setLinearVelocity(vel)
end

function EulerFromQuaternion(q)
	local mat = q:toMat3()
	return Vec3(math.atan2(-mat.m20,mat.m00),math.asin(mat.m10),math.atan2(-mat.m12,mat.m11))
end


function QuaternionFromEuler(xAngle, yAngle, zAngle)
    return Quaternion(Vec3(1.0, 0.0, 0.0), xAngle) -- Rotation about the X axis
         * Quaternion(Vec3(0.0, 1.0, 0.0), yAngle) -- Rotation about the Y axis
         * Quaternion(Vec3(0.0, 0.0, 1.0), zAngle) -- Rotation about the Z axis
end

box = GameObjectManager:createGameObject("box")
box.pc = box:createPhysicsComponent()
cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createBox(Vec3(8,8,0.1))
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 10
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
cinfo.mass = 100.0
cinfo.restitution = 0.5
cinfo.position = Vec3(0,0,-1)
cinfo.maxLinearVelocity = 10
ball.rb = ball.pc:createRigidBody(cinfo)

function update(deltaTime)
	local pos = ball.rb:getPosition()
	if(pos.z < -5) then
		ball.rb:setPosition(Vec3(0,0,5))
	end
end

--Events.Update:registerListener(update)

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