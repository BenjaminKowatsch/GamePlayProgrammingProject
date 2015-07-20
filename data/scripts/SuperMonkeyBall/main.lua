		-- https://github.com/pampersrocker/risky-epsilon/blob/master/Game/data/scripts/Camera/IsometricCamera.lua
-- physics world
gravityFactor = -1
do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,9.8*gravityFactor)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	world:setCollisionFilter(PhysicsFactory:createCollisionFilter_Simple())
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)
end

-- Dependencies
--include("SuperMonkeyBall/helper.lua")
--include("SuperMonkeyBall/ball.lua")
--include("SuperMonkeyBall/camera.lua")
include("SuperMonkeyBall/Player.lua")
include("SuperMonkeyBall/box.lua")
include("SuperMonkeyBall/mainmenu.lua")
include("SuperMonkeyBall/PickupBase.lua")
include("SuperMonkeyBall/DoubleJumpPickup.lua")
include("SuperMonkeyBall/GravityPickup.lua")
--include("SuperMonkeyBall/banana.lua")

pickupbase = PickupBase("PickupBase",Vec3(-50,50,0),0x1,15,15,15)

--ball = createBall()
--local capsule = createCollisionCapsule("capsule",Vec3(0,0,-250),Vec3(0,0,500),40)
--capsule:setPosition(ball:getPosition())

pickup = DoubleJumpPickup("DoubleJumpPickup",Vec3(30,0,0),0x1,15,15,15)

gravityPickup = GravityPickup("GravityPickup",Vec3(30,30,0),0x1,15,15,15)

gravityPickup2 = GravityPickup("GravityPickup2",Vec3(30,-30,181),0x1,15,15,15)

box = createBox(Vec3(0,0,-4),"box")

box2 = createBox(Vec3(0,0,200),"box1")

player = createPlayer()

--cam = createCamera("camera",ball,Vec3(0,-50,20))

function defaultUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	player:update(elapsedTime)
	---- keyboard player input
	--local move = Vec2(0, 0)
	--if (InputHandler:isPressed(Key.A)) then move.x = - 1 end
	--if (InputHandler:isPressed(Key.D)) then move.x = 1 end
	--if (InputHandler:isPressed(Key.W)) then move.y = 1 end
	--if (InputHandler:isPressed(Key.S)) then move.y = -1 end
	--move = move:normalized()
	---- gamepad player input
	--local gamepad = InputHandler:gamepad(0)
	--local leftStick = gamepad:leftStick()
	--local rightStick = gamepad:rightStick()
	---- mouse player input
	--local mouseDelta = InputHandler:getMouseDelta()
	--
	----DebugRenderer:printText(Vec2(-0.2,0.7),"MouseDelta: " .. mouseDelta.x .." " .. mouseDelta.y .. " " .. mouseDelta.z.."\nBoxPosition ".. box:getWorldPosition().x.." ".. box:getWorldPosition().y.." ".. box:getWorldPosition().z .. "\nBallPosition "..ball:getWorldPosition().x.." ".. ball:getWorldPosition().y.." ".. ball:getWorldPosition().z)
	--if InputHandler:wasTriggered(Key.G) then
	--	gravityFactor = -gravityFactor
	--	PhysicsSystem:getWorld():setGravity(Vec3(0,0,9.8*gravityFactor))
	--	player.cam.camOffset.z = -player.cam.camOffset.z
	--	player.cam.cc:tilt(180)
	--end
	--move = move + leftStick
	--move.x = move.x * -gravityFactor
	--local zoom = mouseDelta.z + rightStick.y	
	--
	--if(InputHandler:wasTriggered(Key.Space) or bit32.btest(gamepad:buttonsTriggered(), Button.A)) then
	--	player.ball.jump()
	--end
	--
	--local moveVector3Rot = cam:update(elapsedTime,move,zoom)
	--
	--player.ball:update(elapsedTime,Vec2(moveVector3Rot.x,moveVector3Rot.y))
	--capsule:update((ball:getPosition()-capsule.rb:getPosition()),elapsedTime)
	
	
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