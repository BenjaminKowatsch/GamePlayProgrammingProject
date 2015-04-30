
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
rotationSpeed = 40
maxAngle = 20
local n = Vec3(0,0,1)
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
	
	
	local AngularVelocity = Vec3(0,0,0)
	local up = Vec3(0,0,1)
	
	if(InputHandler:isPressed(Key.Right))  then
		AngularVelocity.y = 1
	end
	if(InputHandler:isPressed(Key.Left)) then
		AngularVelocity.y =-1
	end
	if(InputHandler:isPressed(Key.Down)) then
		AngularVelocity.x =1
	end
	if(InputHandler:isPressed(Key.Up)) then
		AngularVelocity.x =-1
	end
	
	if (AngularVelocity:squaredLength()~= 0) then
		AngularVelocity = AngularVelocity:normalized()	
		AngularVelocity = AngularVelocity:mulScalar(rotationSpeed * deltaTime)
	end
	
	box.rb:setAngularVelocity(AngularVelocity)
	n = n + AngularVelocity
	
	cam.cc:setPosition(ball:getWorldPosition():add(Vec3(0,-10,5)))
	cam.cc:setViewTarget(ball)
	
	local rotation = EulerFromQuaternion(box:getRotation())
	DebugRenderer:printText(Vec2(0.2,0.2),
							" " .. angleBetweenVec3(up,n),
							Color(1,0,0,1))
	
	--box.rb:setLinearVelocity(vel)
end

function angleBetweenVec3(a,b)
	return math.acos((a.x*b.x+a.y*b.y+a.z*b.z )/(a:length()*b:length()))
end

function EulerFromQuaternion(q)
	local mat = q:toMat3()
	--return Vec3(math.atan2(-mat.m20,mat.m00),
	--			math.asin(mat.m10),
	--			math.atan2(-mat.m12,mat.m11))
	
	--return Vec3(math.atan2(mat.m21,mat.m22),
	--			math.atan2(-mat.m20,math.sqrt(mat.m21*mat.m21+mat.m22*mat.m22)),
	--			math.atan2(mat.m10,mat.m00))
	--local b  = math.atan2(-mat.m20,math.sqrt(mat.m00*mat.m00+mat.m10*mat.m10))
	--if(b == math.pi/2 ) then
	--		return Vec3(0,b,math.atan2(mat.m01,mat.m11))
	--	elseif (b == -math.pi/2) then
	--		return Vec3(0,b,-math.atan2(mat.m01,mat.m11))			
	--	else
	--	return Vec3(math.atan2(mat.m10,mat.m00),b,math.atan2(mat.m21,mat.m22))	
	--end
	return Vec3(math.atan2(mat.m20,mat.m21),
				math.acos(mat.m22),
				-math.atan2(mat.m02,mat.m12))
end


function QuaternionFromEuler(xAngle, yAngle, zAngle)
    return Quaternion(Vec3(1.0, 0.0, 0.0), xAngle) -- Rotation about the X axis
         * Quaternion(Vec3(0.0, 1.0, 0.0), yAngle) -- Rotation about the Y axis
         * Quaternion(Vec3(0.0, 0.0, 1.0), zAngle) -- Rotation about the Z axis
end

box = GameObjectManager:createGameObject("box")
box.pc = box:createPhysicsComponent()
cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createBox(Vec3(15,15,0.1))
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
cinfo.mass = 0.3
cinfo.rollingFrictionMultiplier = 0.2
cinfo.linearDamping = 0.4
cinfo.angularDamping = 0.4
cinfo.restitution = 0.8
cinfo.friction = 0.7
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