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
include("SuperMonkeyBall/Respawn.lua")
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
include("SuperMonkeyBall/Level0.lua")
include("SuperMonkeyBall/Level1.lua")
include("SuperMonkeyBall/Level2.lua")
include("SuperMonkeyBall/Level3.lua")
include("SuperMonkeyBall/Level4.lua")
include("SuperMonkeyBall/Level5.lua")


respawn = createRespawn()
--Initialization
rotplatform = RotationPlatform()
movplatform = MovingPlatform()

player = createPlayer()

level0 = Level0()
level1 = Level1()
level2 = Level2()
level3 = Level3()
level4 = Level4()
level5 = Level5()

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
local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

function mainmenuEnter()

	player.ball:setComponentStates(ComponentState.Active)
	level0:create()
	player.ball:setPosition(Vec3(0,0,14))
	player.ball.rb:setLinearVelocity(Vec3(0,0,0))	
end
function mainmenuLeave()
	level0:destroy()

end
function level1Enter()
	level1:create()
	player.ball:setPosition(Vec3(0,0,14))
	player.ball.rb:setLinearVelocity(Vec3(0,0,0))
end
function level1Leave()
	level1:destroy()
	respawn.goal = false
end
function level2Enter()
	level2:create()
	player.ball:setPosition(Vec3(0,0,14))
	player.ball.rb:setLinearVelocity(Vec3(0,0,0))
end
function level2Leave()
	level2:destroy()
	respawn.goal = false
end
function level3Enter()
	level3:create()
	player.ball:setPosition(Vec3(0,0,14))
	player.ball.rb:setLinearVelocity(Vec3(0,0,0))
end
function level3Leave()
	level3:destroy()
	respawn.goal = false
end
function level4Enter()
	level4:create()
	player.ball:setPosition(Vec3(0,0,14))
	player.ball.rb:setLinearVelocity(Vec3(0,0,0))
end
function level4Leave()
	level4:destroy()
	respawn.goal = false
end
function level5Enter()
	level5:create()
	player.ball:setPosition(Vec3(0,0,14))
	player.ball.rb:setLinearVelocity(Vec3(0,0,0))
end
function level5Leave()
	level5:destroy()
	respawn.goal = false
end
function scoreEnter()
	player.ball:setComponentStates(ComponentState.Inactive)
end
function scoreUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0,0), "Score: "..tostring(player.ball.coinCount))
	player:update(elapsedTime)
	--speedPickup:update(elapsedTime)
	return EventResult.Handled
end

function scoreLeave()
	player.ball.coinCount = 0
	respawn.goal = false
end
function defaultUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	--level0:update(elapsedTime)
	--DebugRenderer:printText(Vec2(-0.9,0.7), "Speed: "..tostring(player.ball.maxSpeed))
	DebugRenderer:printText(Vec2(-0.9,0.5), "Score: "..tostring(player.ball.coinCount))
	player:update(elapsedTime)
	--speedPickup:update(elapsedTime)
	--movplatform:update(elapsedTime)
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
				update = { defaultUpdate },
				leave  = { level3Leave }
			}
		},
		{
			name = "level4",
			eventListeners = {
				enter  = { level4Enter },
				update = { defaultUpdate },
				leave  = { level4Leave }
			}
		},
		{
			name = "level5",
			eventListeners = {
				enter  = { level5Enter },
				update = { defaultUpdate },
				leave  = { level5Leave }
			}
		},
		{
			name = "score",
			eventListeners = {
				enter  = { scoreEnter },
				update = { scoreUpdate },
				leave  = { scoreLeave }
			}
		}

	},
	transitions =
	{
		{ from = "__enter", to = "mainmenu" },
		{ from = "mainmenu", to = "level1", condition = function() return level0.glevel1.goal end },
		{ from = "mainmenu", to = "level2", condition = function() return level0.glevel2.goal end },
		{ from = "mainmenu", to = "level3", condition = function() return level0.glevel3.goal end },
		{ from = "mainmenu", to = "level4", condition = function() return level0.glevel4.goal end },
		{ from = "mainmenu", to = "level5", condition = function() return level0.glevel5.goal end },
		{ from = "level1", to = "mainmenu", condition = function() return respawn.goal end },
		{ from = "level2", to = "mainmenu", condition = function() return respawn.goal end },
		{ from = "level3", to = "mainmenu", condition = function() return respawn.goal end },
		{ from = "level4", to = "mainmenu", condition = function() return respawn.goal end },
		{ from = "level5", to = "mainmenu", condition = function() return respawn.goal end },
		{ from = "level1", to = "score", condition = function() return level1.goal.goal end },
		{ from = "level2", to = "score", condition = function() return level2.goal.goal end },
		{ from = "level3", to = "score", condition = function() return level3.goal.goal end },
		{ from = "level4", to = "score", condition = function() return level4.goal.goal end },
		{ from = "level5", to = "score", condition = function() return level5.goal.goal end },
		{ from = "score", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.Space) end }

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