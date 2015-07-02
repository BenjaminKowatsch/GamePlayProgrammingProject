		-- https://github.com/pampersrocker/risky-epsilon/blob/master/Game/data/scripts/Camera/IsometricCamera.lua
-- Dependencies
include("SuperMonkeyBall/ball.lua")
include("SuperMonkeyBall/box.lua")
include("SuperMonkeyBall/mainmenu.lua")
include("SuperMonkeyBall/Pickup.lua")
--include("SuperMonkeyBall/banana.lua")

-- physics world
do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.8)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	world:setCollisionFilter(PhysicsFactory:createCollisionFilter_Simple())
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)
end

ball = createBall()
--ball.moveSpeed = 40
--banana = createBanana()
pickup = createPickup(ball)

--local myTrigger = GameObjectManager:createGameObject("myTrigger")
--myTrigger.physics = myTrigger:createPhysicsComponent()
--local cinfo = RigidBodyCInfo()
--	cinfo.collisionFilterInfo = 0x1
--    cinfo.motionType      = MotionType.Fixed
--	cinfo.position=Vec3(30,0,0)
--    cinfo.shape           = PhysicsFactory:createSphere(20) -- 1 meter
--    cinfo.isTriggerVolume = true -- Don't forget this! ;)
--myTrigger.rigidBody = myTrigger.physics:createRigidBody(cinfo)
--myTrigger.rigidBody:getTriggerEvent():registerListener(function(args)
--    ball.rb:setLinearVelocity(ball.rb:getLinearVelocity():add(Vec3(0,0,40)))
--end)

box = createBox()

function createCollisionCapsule(guid, startPos, endPos, radius)
	local capsule = GameObjectManager:createGameObject(guid)
	capsule.pc = capsule:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createCapsule(startPos, endPos, radius)
	cinfo.motionType = MotionType.Keyframed
	cinfo.collisionFilterInfo = 0x2
	capsule.pc.rb = capsule.pc:createRigidBody(cinfo)
	return capsule
end

local capsule = createCollisionCapsule("capsule",Vec3(0,0,0),Vec3(0,0,100),40)
capsule:setPosition(ball:getPosition())
--box.maxAngle = 10
--box.rotationSpeed = 30

local counter=0
local maxCounter = 25
local tiltSpeed = 60

local cAngle = 0
local camOffset = Vec3(0,-50,40)
local minLength = camOffset:length()
cam = GameObjectManager:createGameObject("cam")
cam.cc = cam:createCameraComponent()
cam.cc:setPosition(Vec3(0,0,0))
cam.cc:setViewTarget(ball)
cam.cc:setState(ComponentState.Active)
cam.pc = cam:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.shape = PhysicsFactory:createSphere(2.5)
cinfo.motionType = MotionType.Dynamic
cinfo.mass = 50.0
cinfo.gravityFactor = 0
cinfo.restitution = 0.0
cinfo.position = ball:getWorldPosition():add(camOffset)
cinfo.friction = 0.0
cinfo.maxLinearVelocity = 3000
cinfo.linearDamping = 5.0
cinfo.gravityFactor = 0.0
cinfo.collisionFilterInfo = 0x2
cam.pc.rb = cam.pc:createRigidBody(cinfo)

local newCamPos = cam.pc.rb:getPosition()

function defaultUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	
	-- WASD
	local move = Vec2(0, 0)
	if (InputHandler:isPressed(Key.A)) then move.x = - 1 end
	if (InputHandler:isPressed(Key.D)) then move.x = 1 end
	if (InputHandler:isPressed(Key.W)) then move.y = 1 end
	if (InputHandler:isPressed(Key.S)) then move.y = -1 end
	move = move:normalized()
	
	-- gamepad input
	local gamepad = InputHandler:gamepad(0)
	local leftStick = gamepad:leftStick()
	local rightStick = gamepad:rightStick()
	
	-- mose input
	local mouseDelta = InputHandler:getMouseDelta()
	
	--DebugRenderer:printText(Vec2(-0.2,0.7),"MouseDelta: " .. mouseDelta.x .." " .. mouseDelta.y .. " " .. mouseDelta.z.."\nBoxPosition ".. box:getWorldPosition().x.." ".. box:getWorldPosition().y.." ".. box:getWorldPosition().z .. "\nBallPosition "..ball:getWorldPosition().x.." ".. ball:getWorldPosition().y.." ".. ball:getWorldPosition().z)
	
	move = move + leftStick
	if(InputHandler:wasTriggered(Key.Space) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.A)) then
		ball.jump()
	end
	
	--box:update(elapsedTime,move)
	local zoom = mouseDelta.z + rightStick.y
	
	-- set zoom
	--if(zoom~=0) then
	--	local newoffset = camOffset:add(camOffset:normalized():mulScalar(-zoom*30))
	--	if(minLength<=newoffset:length()) then
	--		camOffset = newoffset
	--	end
	--end

	-- tilt camera
	if (move.x~=0) then
		if(move.x<0 and counter > -maxCounter) then
			cam.cc:tilt(-tiltSpeed*elapsedTime)
			counter = counter-1
		elseif (move.x>0 and counter <maxCounter) then
			cam.cc:tilt(tiltSpeed*elapsedTime)
			counter = counter+1
		end
	else
		if(counter>0) then	
			cam.cc:tilt(-tiltSpeed*elapsedTime)
			counter = counter -1
		elseif(counter<0) then	
			cam.cc:tilt(tiltSpeed*elapsedTime)
			counter = counter +1
		end
	end

	local camBallDiff = ball:getPosition()-cam.pc.rb:getPosition()
	local relativeControlsAngle = -angleBetweenVec2(Vec2(camBallDiff.x,camBallDiff.y),Vec2(0,1))
	local z = Quaternion(Vec3(0.0, 0.0, 1.0), relativeControlsAngle)
	local moveVector3Rot = z:toMat3():mulVec3(Vec3(move.x,move.y,0))
	
	local ballVel = ball.rb:getLinearVelocity()
	
	if(move:length() > 0) then
		local offsetAngle = angleBetweenVec2(Vec2(-camOffset.x,-camOffset.y),Vec2(ballVel.x,ballVel.y))
		local q = Quaternion(Vec3(0.0, 0.0, 1.0), offsetAngle)
		camOffset = q:toMat3():mulVec3(camOffset)
		local ballPos = ball:getPosition()
		newCamPos = ballPos+camOffset		
		
		--DebugRenderer:drawArrow(ball:getPosition(), ball:getPosition() + Vec3(ballVel.x,ballVel.y,0):mulScalar(6), Color(0, 1, 0, 1))
		--DebugRenderer:drawArrow(ball:getPosition(), ball:getPosition() + ballVel:mulScalar(10), Color(0, 0, 1, 1))
	end	
	local camMoveDir = (newCamPos-cam.pc.rb:getPosition()):mulScalar(elapsedTime*800)
	ball:update(elapsedTime,Vec2(moveVector3Rot.x,moveVector3Rot.y))
	
	--cam.pc.rb:setLinearVelocity(camMoveDir)
	cam.pc.rb:applyLinearImpulse(camMoveDir)
	
	cam.cc:setViewTarget(ball)
	
	local rightDir = cam.cc:getViewDirection():cross(Vec3(0,0,1))
	cam.cc:setUpDirection(rightDir:cross(cam.cc:getViewDirection()))
	
	local capsuleVel = ball:getPosition()-capsule:getPosition()
	capsule.pc.rb:setLinearVelocity(capsuleVel:mulScalar(30))
	
	--local rollAngle = 0
	--if(move.y~=0) then
	--	if(move.y<0) then
	--		rollAngle = 30
	--	else
	--		rollAngle = -30
	--	end
	--end
	--DebugRenderer:printText(Vec2(-0.2,0.7),"RollAngle: " .. rollAngle)
	--
	--local camRoll = Quaternion(cam.cc:getRightDirection(),-50)
	--cam.cc:setUpDirection(cam.cc:getUpDirection():add(Vec3(0,0,0)))
	
	return EventResult.Handled
end



function angleBetweenVec2(vector1, vector2)
	local angleRad = math.atan2(vector2.y, vector2.x) - math.atan2(vector1.y, vector1.x)
	local angleDeg = (angleRad/math.pi)*180
	if (angleDeg > 180) then
		angleDeg = angleDeg - 360
	end
	if (angleDeg < -180) then
		angleDeg = angleDeg + 360
	end
	return angleDeg
end

--Events.PostInitialization:registerListener(function()
--local cinfo = {
--    type = ConstraintType.BallAndSocket, -- The constraint type
--    A = box.rb,                   -- Take care not to use the game object but its rigid body!
--    B = nil,                -- If you omit this one (or set it to nil), the physics world itself is used as B
--    constraintSpace = "world", -- Wether the given pivot or pivots are in world or in local (body) space
--    -- Only required if constraintSpace == "world"
--    pivot = box:getWorldPosition(), -- Global coordinates
--}
--local constraint = PhysicsFactory:createConstraint(cinfo)
--PhysicsSystem:getWorld():addConstraint(constraint) -- 'world' must have been created earlier at some point, of course
--end)

-- global state machine
State{
	name = "default",
	parent = "/game",
	eventListeners = {
		update = { defaultUpdate }
	}
}
StateTransitions{
	parent = "/game",
	{ from = "__enter", to = "mainmenu" }
}

StateTransitions{
	parent = "/game",
	{ from = "mainmenu", to = "default", condition = function() return InputHandler:wasTriggered(Key.F1) end}
}
StateTransitions{
	parent = "/game",
	{ from = "default", to = "__leave", condition = function() return InputHandler:wasTriggered(Key.Escape) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.Back) end }
}