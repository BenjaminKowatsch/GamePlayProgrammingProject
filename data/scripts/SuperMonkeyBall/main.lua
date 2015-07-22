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
include("SuperMonkeyBall/SpeedPickup.lua")
include("SuperMonkeyBall/PlatformBase.lua")
include("SuperMonkeyBall/RotationPlatform.lua")
include("SuperMonkeyBall/MovingPlatform.lua")
include("SuperMonkeyBall/CoinPickup.lua")
include("SuperMonkeyBall/Goal.lua")
include("SuperMonkeyBall/Level.lua")
include("SuperMonkeyBall/Level1.lua")
include("SuperMonkeyBall/Level2.lua")
include("SuperMonkeyBall/Level3.lua")
--include("SuperMonkeyBall/Level4.lua")

--include("SuperMonkeyBall/banana.lua")

rotplatform = RotationPlatform("rotplatform",Vec3(60,-60,20),0x1,60,60,5,40,40)

movplatform = MovingPlatform("movplatform",Vec3(60,80,-4),0x1,30,30,5,1600,Vec3(60,120,30))

--pickupbase = PickupBase("PickupBase",Vec3(-50,50,0),0x1,15,15,15)

--pickup = DoubleJumpPickup("DoubleJumpPickup",Vec3(30,0,0),0x1,15,15,15)

background = GameObjectManager:createGameObject("background")
background.rc = background:createRenderComponent()
background.rc:setPath("data/models/Background/Background.FBX")
background.pc = background:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Keyframed
cinfo.shape = PhysicsFactory:createSphere(500)
cinfo.mass = 10
cinfo.collisionFilterInfo = 0x4
cinfo.position = Vec3(0,0,0)
background.rb = background.pc:createRigidBody(cinfo)

--box = createBox(Vec3(0,0,-4),"box")

--gravityPickup = GravityPickup("GravityPickup",Vec3(40,40,0),0x1,15,15,15)

--gravityPickup2 = GravityPickup("GravityPickup2",Vec3(40,-40,181),0x1,15,15,15)

speedPickup = SpeedPickup("SpeedPickup",Vec3(-100,60,0),0x1,15,15,15,2)


coinPickup = CoinPickup("CoinPickup", Vec3(100,30,0),0x1,5,5,5,4)
coinPickup2 = CoinPickup("CoinPickup2", Vec3(100,40,0),0x1,5,5,5,4)
coinPickup3 = CoinPickup("CoinPickup3", Vec3(100,50,0),0x1,5,5,5,4)
coinPickup4 = CoinPickup("CoinPickup4", Vec3(100,60,0),0x1,5,5,5,4)
coinPickup5 = CoinPickup("CoinPickup5", Vec3(100,70,0),0x1,5,5,5,4)

--box2 = createBox(Vec3(0,0,200),"box1")

player = createPlayer()

--box2 = createBox(Vec3(0,0,200),"box1")

--cam = createCamera("camera",ball,Vec3(0,-50,20))
level1 = Level1()
level1:setComponentStates(ComponentState.Inactive)
level2 = Level2()
level2:setComponentStates(ComponentState.Inactive)
level3 = Level3()
level3:setComponentStates(ComponentState.Inactive)
--level4 = Level4()
--level4:setComponentStates(ComponentState.Inactive)
local activeLevel
function mainmenuEnter()
	level1:setComponentStates(ComponentState.Active)
	activeLevel = "mainmenu"
	level2.goal2.goal = false

	player.ball:setPosition(Vec3(0,0,14))
	--player.capsule:setPosition(player.ball:getPosition())
end
function mainmenuLeave()
	level1:setComponentStates(ComponentState.Inactive)
end

function level2Enter()
	level2:setComponentStates(ComponentState.Active)
	level1.goal1.goal = false
	activeLevel = "level2"
	player.ball:setPosition(Vec3(0,0,14))
	player.capsule:setPosition(player.ball:getPosition())
end
function level2Leave()
	level2:setComponentStates(ComponentState.Inactive)
end
function defaultUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(-0.9,0.7), "Goal: "..tostring(level2.goal2.goal))
	DebugRenderer:printText(Vec2(-0.9,0.6), "Level: "..tostring(activeLevel))
	player:update(elapsedTime)
	speedPickup:update(elapsedTime)
	movplatform:update(elapsedTime)
	DebugRenderer:printText3D(Vec3(-100,60,16), "Text3D colored!", Color(0,0,1,1))
	rotplatform:update(elapsedTime)

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
		},
		{
			name = "score",
			eventListeners = {
				enter  = { scoreEnter },
				update = { defaultUpdate },
				leave  = { scoreLeave }
			}
		}

	},
	transitions =
	{
		{ from = "__enter", to = "mainmenu" },
		{ from = "mainmenu", to = "level1", condition = function() return InputHandler:wasTriggered(Key.F1) end },
		{ from = "mainmenu", to = "level2", condition = function() return level1.goal1.goal end },
		{ from = "mainmenu", to = "level3", condition = function() return InputHandler:wasTriggered(Key.F3) end },
		{ from = "mainmenu", to = "level4", condition = function() return InputHandler:wasTriggered(Key.F4) end },
		{ from = "mainmenu", to = "level5", condition = function() return InputHandler:wasTriggered(Key.F5) end },
		{ from = "level1", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level2", to = "mainmenu", condition = function() return level2.goal2.goal end },
		{ from = "level3", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level4", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level5", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level1", to = "score", condition = function() return InputHandler:wasTriggered(Key.F5) end },
		{ from = "level2", to = "score", condition = function() return InputHandler:wasTriggered(Key.F2) end },
		{ from = "level3", to = "score", condition = function() return InputHandler:wasTriggered(Key.F3) end },
		{ from = "level4", to = "score", condition = function() return InputHandler:wasTriggered(Key.F4) end },
		{ from = "level5", to = "score", condition = function() return InputHandler:wasTriggered(Key.F5) end }
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