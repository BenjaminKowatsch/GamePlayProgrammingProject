		-- https://github.com/pampersrocker/risky-epsilon/blob/master/Game/data/scripts/Camera/IsometricCamera.lua
-- physics world
gravityFactor = -1
do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,9.8*gravityFactor)
	cinfo.worldSize = 2000
	local world = PhysicsFactory:createWorld(cinfo)
	--world:setCollisionFilter(PhysicsFactory:createCollisionFilter_Simple())
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
include("SuperMonkeyBall/SpeedPickup.lua")
include("SuperMonkeyBall/level1.lua")
include("SuperMonkeyBall/PlatformBase.lua")
include("SuperMonkeyBall/RotationPlatform.lua")
include("SuperMonkeyBall/MovingPlatform.lua")
--include("SuperMonkeyBall/banana.lua")

rotplatform = RotationPlatform("rotplatform",Vec3(60,-60,20),0x1,60,60,5,40,40)

movplatform = MovingPlatform("movplatform",Vec3(60,80,-4),0x1,30,30,5,1600,Vec3(60,120,30))

--pickupbase = PickupBase("PickupBase",Vec3(-50,50,0),0x1,15,15,15)

--pickup = DoubleJumpPickup("DoubleJumpPickup",Vec3(30,0,0),0x1,15,15,15)

--background = GameObjectManager:createGameObject("background")
--background.rc = background:createRenderComponent()
--background.rc:setPath("data/models/Background/Background.FBX")
--background.pc = background:createPhysicsComponent()
--local cinfo = RigidBodyCInfo()
--cinfo.motionType = MotionType.Keyframed
--cinfo.shape = PhysicsFactory:createSphere(500)
--cinfo.collisionFilterInfo = 0x0
--cinfo.mass = 10
--------------------------------------
----cinfo.collisionFilterInfo = 0x4
--------------------------------------
--cinfo.position = Vec3(0,0,0)
--background.rb = background.pc:createRigidBody(cinfo)

--box = createBox(Vec3(0,0,-4),"box")

--gravityPickup = GravityPickup("GravityPickup",Vec3(40,40,0),0x1,15,15,15)

--gravityPickup2 = GravityPickup("GravityPickup2",Vec3(40,-40,181),0x1,15,15,15)

speedPickup = SpeedPickup("SpeedPickup",Vec3(-100,60,0),0x1,15,15,15,2)

box2 = createBox(Vec3(0,0,200),"box1")

player = createPlayer()

--box2 = createBox(Vec3(0,0,200),"box1")

--cam = createCamera("camera",ball,Vec3(0,-50,20))
level1 = createLevel1(Vec3(0,0,-4), "level1")
level1:setComponentStates(ComponentState.Inactive)
level2 = createLevel1(Vec3(0,0,-4), "level2")
level2:setComponentStates(ComponentState.Inactive)
level3 = createLevel1(Vec3(0,0,-4), "level3")
level3:setComponentStates(ComponentState.Inactive)
level4 = createLevel1(Vec3(0,0,-4), "level4")
level4:setComponentStates(ComponentState.Inactive)

function mainmenuEnter()
	level1:setComponentStates(ComponentState.Active)
end
function mainmenuLeave()
	level1:setComponentStates(ComponentState.Inactive)
end

function level2Enter()
	level2:setComponentStates(ComponentState.Active)
	player.ball:setPosition(Vec3(0,0,14))
	player.capsule:setPosition(player.ball:getPosition())
end
function level2Leave()
	level2:setComponentStates(ComponentState.Inactive)
end
function defaultUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	player:update(elapsedTime)
	speedPickup:update(elapsedTime)
	movplatform:update(elapsedTime)
	DebugRenderer:printText3D(Vec3(-100,60,16), "Text3D colored!", Color(0,0,1,1))
	rotplatform:update(elapsedTime)
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

-- global state machine
StateMachine{
	name = "pjStateMachine",
	parent = "/game",
	states =
	{
		{
			name = "mainmenu",
			eventListeners = {
				enter  = { mainmenuEnter },
				update = { defaultUpdate },
				leave  = { mainmenuLeave }
			}
		},
		{
			name = "level1",
			eventListeners = {
				enter  = { level1Enter },
				update = { defaultUpdate },
				leave  = { level1Leave }
			}
		},
		{
			name = "level2",
			eventListeners = {
				enter  = { level2Enter },
				update = { defaultUpdate },
				leave  = { level2Leave }
			}
		},
		{
			name = "level3",
			eventListeners = {
				enter  = { level3Enter },
				update = { level3Update },
				leave  = { level3Leave }
			}
		},
		{
			name = "level4",
			eventListeners = {
				enter  = { level4Enter },
				update = { level4Update },
				leave  = { level4Leave }
			}
		},
		{
			name = "level5",
			eventListeners = {
				enter  = { level5Enter },
				update = { level5Update },
				leave  = { level5Leave }
			}
		}
	},
	transitions =
	{
		{ from = "__enter", to = "mainmenu" },
		{ from = "mainmenu", to = "level1", condition = function() return InputHandler:wasTriggered(Key.F1) end },
		{ from = "level1", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "mainmenu", to = "level2", condition = function() return InputHandler:wasTriggered(Key.F2) end },
		{ from = "mainmenu", to = "level3", condition = function() return InputHandler:wasTriggered(Key.F3) end },
		{ from = "mainmenu", to = "level4", condition = function() return InputHandler:wasTriggered(Key.F4) end },
		{ from = "mainmenu", to = "level5", condition = function() return InputHandler:wasTriggered(Key.F5) end }
	},
	eventListeners =
	{
		enter = { pjStateMachineEnter }
	}
}

StateTransitions{
	parent = "/game",
	{ from = "__enter", to = "pjStateMachine" },
	{ from = "pjStateMachine", to = "__leave", condition = function() return InputHandler:wasTriggered(Key.Escape) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.Back) end }
}