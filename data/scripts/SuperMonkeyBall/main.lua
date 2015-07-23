		-- https://github.com/pampersrocker/risky-epsilon/blob/master/Game/data/scripts/Camera/IsometricCamera.lua
-- physics world
gravityFactor = -1
do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0,9.8*gravityFactor)
	cinfo.worldSize = 4000
	local world = PhysicsFactory:createWorld(cinfo)
	world:setCollisionFilter(PhysicsFactory:createCollisionFilter_Simple())
	PhysicsSystem:setWorld(world)
	PhysicsSystem:setDebugDrawingEnabled(true)
end

--Dependencies
include("SuperMonkeyBall/Player.lua")
include("SuperMonkeyBall/box.lua")
include("SuperMonkeyBall/PickupBase.lua")
include("SuperMonkeyBall/DoubleJumpPickup.lua")
include("SuperMonkeyBall/GravityPickup.lua")
include("SuperMonkeyBall/SpeedPickup.lua")
include("SuperMonkeyBall/PlatformBase.lua")
include("SuperMonkeyBall/RotationPlatform.lua")
include("SuperMonkeyBall/MovingPlatform.lua")
include("SuperMonkeyBall/CoinPickup.lua")
include("SuperMonkeyBall/Goal.lua")
include("SuperMonkeyBall/LevelBase.lua")
include("SuperMonkeyBall/Level1.lua")
include("SuperMonkeyBall/Level2.lua")
include("SuperMonkeyBall/Level3.lua")
include("SuperMonkeyBall/Level4.lua")



--Initialization
rotplatform = RotationPlatform()
movplatform = MovingPlatform()

player = createPlayer()

level1 = Level1()
level2 = Level2()
level3 = Level3()
level4 = Level4()

background = GameObjectManager:createGameObject("background")
background.rc = background:createRenderComponent()
background.rc:setPath("data/models/Background.FBX")
background.pc = background:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Keyframed
cinfo.shape = PhysicsFactory:createSphere(1000)
cinfo.rotation = Quaternion(Vec3(0,0,1),180)
cinfo.mass = 10
cinfo.collisionFilterInfo = 0x4
cinfo.position = Vec3(0,0,0)
background.rb = background.pc:createRigidBody(cinfo)
--speedPickup = SpeedPickup()

function mainmenuEnter()
	level1:create()
	player.ball:setPosition(Vec3(0,0,14))
end
function mainmenuLeave()
	level1:destroy()
end

function level2Enter()
	level2:create()
	player.ball:setPosition(Vec3(0,536.776,14))
end
function level2Leave()
	level2:destroy()
end
function scoreEnter()
	player.ball:setComponentStates(ComponentState.Inactive)
end
function ScoreUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0,0), "Score: "..tostring(player.ball.coinCount))
	player:update(elapsedTime)
	--speedPickup:update(elapsedTime)
	return EventResult.Handled
end

function scoreLeave()
	player.ball.coinCount = 0
end
function defaultUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	level1:update(elapsedTime)
	--DebugRenderer:printText(Vec2(-0.9,0.7), "Goal: "..tostring(level2.goal2.goal))
	DebugRenderer:printText(Vec2(-0.9,0.5), "Score: "..tostring(player.ball.coinCount))
	DebugRenderer:printText(Vec2(-0.8,0.5), "Score: "..tostring(player.ball.jumpCount))
	player:update(elapsedTime)
	--speedPickup:update(elapsedTime)
	--movplatform:update(elapsedTime)
	DebugRenderer:printText3D(Vec3(-100,60,16), "Text3D colored!", Color(0,0,1,1))
	--rotplatform:update(elapsedTime)

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
				update = { ScoreUpdate },
				leave  = { scoreLeave }
			}
		}

	},
	transitions =
	{
		{ from = "__enter", to = "mainmenu" },
		{ from = "mainmenu", to = "level1", condition = function() return InputHandler:wasTriggered(Key.F1) end },
		{ from = "mainmenu", to = "level2", condition = function() return InputHandler:wasTriggered(Key.F2) end },
		{ from = "mainmenu", to = "level3", condition = function() return InputHandler:wasTriggered(Key.F3) end },
		{ from = "mainmenu", to = "level4", condition = function() return InputHandler:wasTriggered(Key.F4) end },
		{ from = "mainmenu", to = "level5", condition = function() return InputHandler:wasTriggered(Key.F5) end },
		{ from = "level1", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level2", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F2) end },
		{ from = "level3", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level4", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level5", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F6) end },
		{ from = "level1", to = "score", condition = function() return InputHandler:wasTriggered(Key.F5) end },
		{ from = "level2", to = "score", condition = function() return InputHandler:wasTriggered(Key.F5) end },
		{ from = "level3", to = "score", condition = function() return InputHandler:wasTriggered(Key.F3) end },
		{ from = "level4", to = "score", condition = function() return InputHandler:wasTriggered(Key.F4) end },
		{ from = "level5", to = "score", condition = function() return InputHandler:wasTriggered(Key.F5) end },
		{ from = "score", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.F1) end }

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