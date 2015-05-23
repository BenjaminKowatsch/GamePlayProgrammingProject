-- Dependencies
include("SuperMonkeyBall/ball.lua")
include("SuperMonkeyBall/box.lua")

-- physics world
do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,-9.3)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)
end

cam = GameObjectManager:createGameObject("cam")
cam.cc= cam:createCameraComponent()
cam.cc:setPosition(Vec3(0,-5,5))
cam.cc:lookAt(Vec3(0,-2.5,0))
cam.cc:setState(ComponentState.Active)

ball = createBall()
--ball.moveSpeed = 40

box = createBox()
box.maxAngle = 10
box.rotationSpeed = 30
local offset = Vec3(0,-8,5)
local counter=0
local maxCounter = 25
local tiltSpeed = 40

local angle=0

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
	
	move = move + leftStick
	local jump = (InputHandler:wasTriggered(Key.Space) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.A))
	
	--box:update(elapsedTime,move)
	
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
	--rotate movement vector relative to camera rotation
	angle = angle -move.x
	local z = Quaternion(Vec3(0.0, 0.0, 1.0), angle)
	local moveVector3Rot = z:toMat3():mulVec3(Vec3(move.x,move.y,0))
	
	--draw rotated movement vector
	--if (moveVector3Rot:length() > 0) then -- FIXME Prevents crash when rendering the arrow
	--	DebugRenderer:drawArrow(ball:getPosition(), ball:getPosition() + moveVector3Rot:mulScalar(5), Color(0, 1, 1, 1))
	--end
	
	ball:update(jump,elapsedTime,Vec2(moveVector3Rot.x,moveVector3Rot.y))
	
	-- rotate camera
	local q = Quaternion(Vec3(0.0, 0.0, 1.0), -move.x)
	offset = q:toMat3():mulVec3(offset)
	
	
	DebugRenderer:printText(Vec2(-0.2,0.5),"Move: " .. move.x .. "  " .. move.y)
	
	cam.cc:setPosition(ball:getWorldPosition():add(offset))
	cam.cc:setViewTarget(ball)
	
	return EventResult.Handled
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
	{ from = "__enter", to = "default" }
}
StateTransitions{
	parent = "/game",
	{ from = "default", to = "__leave", condition = function() return InputHandler:wasTriggered(Key.Escape) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.Back) end }
}
