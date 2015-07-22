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
--include("SuperMonkeyBall/Level4.lua")

rotplatform = RotationPlatform()


movplatform = MovingPlatform()


--background = GameObjectManager:createGameObject("background")
--background.rc = background:createRenderComponent()
--background.rc:setPath("data/models/Background/Background.FBX")
--background.pc = background:createPhysicsComponent()
--local cinfo = RigidBodyCInfo()
--cinfo.motionType = MotionType.Keyframed
--cinfo.shape = PhysicsFactory:createSphere(500)
--cinfo.mass = 10
--cinfo.collisionFilterInfo = 0x4
--cinfo.position = Vec3(0,0,0)
--background.rb = background.pc:createRigidBody(cinfo)

--speedPickup = SpeedPickup()


player = createPlayer()

level1 = Level1()
level2 = Level2()
level3 = Level3()

function mainmenuEnter()
	--movplatform:create("movplatform",Vec3(60,80,-4),0x1,30,30,5,1600,Vec3(60,120,30))
	--rotplatform:create("rotplatform",Vec3(60,-60,20),0x1,60,60,5,40,40)
	--speedPickup:create("SpeedPickup",Vec3(-60,80,0),0x1,15,15,15,level1,2)
	--player.ball:setComponentStates(ComponentState.Active)
	level1:create()
	player.ball:setPosition(Vec3(0,0,14))
end
function mainmenuLeave()
	level1:destroy()
end

function level2Enter()
	level2:create()
	player.ball:setPosition(Vec3(0,0,14))

end
function level2Leave()
	level2:destroy()
end
function defaultUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	level1:update(elapsedTime)
	--DebugRenderer:printText(Vec2(-0.9,0.7), "Goal: "..tostring(level2.goal2.goal))
	DebugRenderer:printText(Vec2(-0.9,0.5), "Score: "..tostring(player.ball.coinCount))
	player:update(elapsedTime)
	--speedPickup:update(elapsedTime)
	--movplatform:update(elapsedTime)
	DebugRenderer:printText3D(Vec3(-100,60,16), "Text3D colored!", Color(0,0,1,1))
	--rotplatform:update(elapsedTime)

	return EventResult.Handled
end

function ScoreUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0,0), "Score: "..tostring(player.ball.coinCount))
	player:update(elapsedTime)
	--speedPickup:update(elapsedTime)
	return EventResult.Handled
end
function scoreEnter()
	player.ball:setComponentStates(ComponentState.Inactive)
end
function scoreLeave()
	player.ball.coinCount = 0
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
		{ from = "mainmenu", to = "level1", condition = function() return InputHandler:wasTriggered(Key.F10) end },
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