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

--dependencies
include("ProjectBall/Player.lua")
include("ProjectBall/Respawn.lua")
include("ProjectBall/PickupBase.lua")
include("ProjectBall/DoubleJumpPickup.lua")
include("ProjectBall/GravityPickup.lua")
include("ProjectBall/SpeedPickup.lua")
include("ProjectBall/PlatformBase.lua")
include("ProjectBall/RotationPlatform.lua")
include("ProjectBall/MovingPlatform.lua")
include("ProjectBall/CoinPickup.lua")
include("ProjectBall/Goal.lua")
include("ProjectBall/LevelBase.lua")
include("ProjectBall/Level0.lua")
include("ProjectBall/Level1.lua")
include("ProjectBall/Level2.lua")
include("ProjectBall/Level3.lua")
include("ProjectBall/Level4.lua")
include("ProjectBall/Level5.lua")

--initialization
player = createPlayer()
respawn = createRespawn("bottom",Vec3(0,0,-700))
--respawnTop = createRespawn("top",Vec3(0,0,1000))

level0 = Level0()
level1 = Level1()
level2 = Level2()
level3 = Level3()
level4 = Level4()
level5 = Level5()

-- create sphere background
background = GameObjectManager:createGameObject("background")
background.rc = background:createRenderComponent()
background.rc:setPath("data/models/Background.FBX")
background.pc = background:createPhysicsComponent()
local cinfo = RigidBodyCInfo()
cinfo.motionType = MotionType.Keyframed
cinfo.shape = PhysicsFactory:createSphere(1000)
cinfo.mass = 10
cinfo.collisionFilterInfo = 0x4
cinfo.position = Vec3(0,120,0)
background.rb = background.pc:createRigidBody(cinfo)

function setGravity(a)
		if gravityFactor > a then
			gravityFactor = -1
			respawn:setPosition(respawn.initPosition)
			PhysicsSystem:getWorld():setGravity(Vec3(0,0,9.8*gravityFactor))
			player.cam.camOffset.z = math.abs(player.cam.camOffset.z)
			player.cam.cc:tilt(180)
		elseif gravityFactor < a then
			gravityFactor = 1
			respawn:setPosition(respawn.initPosition:mulScalar(-1))
			PhysicsSystem:getWorld():setGravity(Vec3(0,0,9.8*gravityFactor))
			player.cam.camOffset.z = -player.cam.camOffset.z
			player.cam.cc:tilt(180)
		end
end

-- state machine events
function mainmenuEnter()
	respawn:setComponentStates(ComponentState.Inactive)
	player.ball:setComponentStates(ComponentState.Active)
	level0:create()
	player:reset(-1,false)
end
function mainmenuLeave()
	level0:destroy()
	respawn:setComponentStates(ComponentState.Active)
end
function mainmenuUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	level0:update(elapsedTime)
	player:update(elapsedTime)
	return EventResult.Handled
end

function level1Enter()
	level1:create()
	player:reset(30,true)
end
function level1Leave()
	level1:destroy()
	respawn.fallOut = false
end
function level1Update(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0.5,-0.6), "Score: "..tostring(player.ball.coinCount))
	level1:update(elapsedTime)
	player:update(elapsedTime)
	return EventResult.Handled
end

function level2Enter()
	level2:create()
	background:setPosition(Vec3(0,500,0))
	player:reset(40,true)
end
function level2Leave()
	level2:destroy()
	respawn.fallOut = false
end
function level2Update(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0.5,-0.6), "Score: "..tostring(player.ball.coinCount))
	level2:update(elapsedTime)
	player:update(elapsedTime)
	return EventResult.Handled
end

function level3Enter()
	level3:create()
	background:setPosition(Vec3(-306,77,340))
	player:reset(90,true)
end
function level3Leave()
	level3:destroy()
	respawn.fallOut = false
end
function level3Update(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0.5,-0.6), "Score: "..tostring(player.ball.coinCount))
	level3:update(elapsedTime)
	player:update(elapsedTime)
	return EventResult.Handled
end

function level4Enter()
	level4:create()
	background:setPosition(Vec3(-50,500,0))
	player:reset(70,true)
end
function level4Leave()
	level4:destroy()
	respawn.fallOut = false
end
function level4Update(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0.5,-0.6), "Score: "..tostring(player.ball.coinCount))
	level4:update(elapsedTime)
	player:update(elapsedTime)
	return EventResult.Handled
end

function level5Enter()
	level5:create()
	background:setPosition(Vec3(0,510,212))
	player:reset(90,true)
end
function level5Leave()
	level5:destroy()
	respawn.fallOut = false
end
function level5Update(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0.5,-0.6), "Score: "..tostring(player.ball.coinCount))
	level5:update(elapsedTime)
	player:update(elapsedTime)
	return EventResult.Handled
end

function scoreEnter()
	player.ball:setComponentStates(ComponentState.Inactive)
end
function scoreLeave()
	player.ball.coinCount = 0
	respawn.fallOut = false
end
function scoreUpdate(updateData)
	local elapsedTime = updateData:getElapsedTime()
	DebugRenderer:printText(Vec2(0,0), "Score: "..tostring(math.floor(player.ball.coinCount+player.timeCounter)))
	DebugRenderer:printText(Vec2(0,0.2), "Remaining time: ".. string.format("%5.2f", player.timeCounter).." s")
	DebugRenderer:printText(Vec2(0,-0.2), "PRESS SPACE/A TO CONTINUE")
	--player:update(elapsedTime)
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
				update = { mainmenuUpdate },
				leave  = { mainmenuLeave }
			}
		},
		{
			name = "level1",
			eventListeners = {
				enter  = { level1Enter },
				update = { level1Update },
				leave  = { level1Leave }
			}
		},
		{
			name = "level2",
			eventListeners = {
				enter  = { level2Enter },
				update = { level2Update },
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
				update = { scoreUpdate },
				leave  = { scoreLeave }
			}
		}

	},
	transitions =
	{
		{ from = "__enter", to = "mainmenu" },
		{ from = "mainmenu", to = "level1", condition = function() return level0.glevel1.goalEntered end },
		{ from = "mainmenu", to = "level2", condition = function() return level0.glevel2.goalEntered end },
		{ from = "mainmenu", to = "level3", condition = function() return level0.glevel3.goalEntered end },
		{ from = "mainmenu", to = "level4", condition = function() return level0.glevel4.goalEntered end },
		{ from = "mainmenu", to = "level5", condition = function() return level0.glevel5.goalEntered end },
		{ from = "level1", to = "mainmenu", condition = function() return respawn.fallOut end },
		{ from = "level2", to = "mainmenu", condition = function() return respawn.fallOut end },
		{ from = "level3", to = "mainmenu", condition = function() return respawn.fallOut end },
		{ from = "level4", to = "mainmenu", condition = function() return respawn.fallOut end },
		{ from = "level5", to = "mainmenu", condition = function() return respawn.fallOut end },
		{ from = "level1", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level2", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level3", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level4", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level5", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level1", to = "score", condition = function() return level1.goal.goalEntered end },
		{ from = "level2", to = "score", condition = function() return level2.goal.goalEntered end },
		{ from = "level3", to = "score", condition = function() return level3.goal.goalEntered end },
		{ from = "level4", to = "score", condition = function() return level4.goal.goalEntered end },
		{ from = "level5", to = "score", condition = function() return level5.goal.goalEntered end },
		{ from = "level1", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level2", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level3", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level4", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "level5", to = "score", condition = function() return player.timeCounter == 0 end },
		{ from = "score", to = "mainmenu", condition = function() return InputHandler:wasTriggered(Key.Space) or bit32.btest(InputHandler:gamepad(0):buttonsTriggered(), Button.A) end }


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