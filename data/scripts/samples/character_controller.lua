logMessage([[Initializing samples/character_controller.lua
  This sample demonstrates how to use the character controller.
  The character controller is used to provide a consistent, easy to use
  interface for controlling any game object in the physics simulation.
]])

include("utils/stateMachine.lua")
include("utils/freeCamera.lua")

do -- Physics world
    local cinfo = WorldCInfo()
    cinfo.gravity = Vec3(0, 0, -9.81)
    physicsWorld = PhysicsFactory:createWorld(cinfo)
    PhysicsSystem:setWorld(physicsWorld)
end

PhysicsSystem:setDebugDrawingEnabled(true)

freeCam.cc:setPosition(Vec3(0, -10, 5))
freeCam.cc:setViewDirection(Vec3(0, 1, 0))
freeCam.cc:setUpDirection(Vec3(0, 0, 1))
freeCam.cc:lookAt(Vec3(0, 0, 2))

do -- Player object.
    player = GameObjectManager:createGameObject("player")
    player.pc = player:createPhysicsComponent()
    local cinfo = CharacterRigidBodyCInfo{
        mass   = 1,
        height = 2,
        radius = 0.3,
        maxLinearVelocity = 100,
    }
    player.rb = player.pc:createRigidBody(cinfo)
    player.rb:setUserData(player)

    function player.onHit(self, rb)
        -- rb is the rigid body the player collided with.
        -- It stores its owner (game object) as user data.
        local other = rb:getUserData()
        logMessage(self:getGuid() .. " got hit by " .. other:getGuid())
    end
    function player.onUpdate(self, dt)
        -- Draw view direction
        local start = player:getPosition() + Vec3(0, 0, 1)
        local dir   = player:getViewDirection()
        DebugRenderer:drawArrow(start, start + dir:mulScalar(1.5),
                                Color(1, 1, 0, 1)) -- yellow
    end
    function player.move(self, dt)
        -- Move forwards/backwards.
        if     InputHandler:isPressed(Key.Up)    then player.rb:applyLinearImpulse( player:getViewDirection():mulScalar(0.5))
        elseif InputHandler:isPressed(Key.Down)  then player.rb:applyLinearImpulse(-player:getViewDirection():mulScalar(0.5))
        end

        -- Rotate.
        if     InputHandler:isPressed(Key.Left)  then player.rb:applyAngularImpulse(player:getUpDirection():mulScalar( 0.03))
        elseif InputHandler:isPressed(Key.Right) then player.rb:applyAngularImpulse(player:getUpDirection():mulScalar(-0.03))
        end

        -- Jump.
        if InputHandler:wasTriggered(Key.Space) then
            player.rb:applyLinearImpulse(player:getUpDirection():mulScalar(4))
        end
    end
    player.controller = CharacterController{
        gameObject          = player,
        --onHit               = player.onHit,    -- could also be an array of listeners
        update              = player.onUpdate, -- could also be an array of listeners
        --controls = {
        --    forward = Key.W,
        --    left    = Key.A,
        --    down    = Key.S,
        --    right   = Key.D,
        --}
    }
    -- Attach new state to the player fsm
    State{
        name = "movement",
        parent = player.controller.fsm.onGround,
        eventListeners = {
            update = {
                function(args) player:move(args:getElapsedTime()) end
            }
        }
    }
    StateTransitions{
        parent = player.controller.fsm.onGround,
        { from = "__enter", to = "movement" },
    }
end

do -- Ground object.
    ground = GameObjectManager:createGameObject("ground")
    ground.pc = ground:createPhysicsComponent()
    local cinfo = RigidBodyCInfo()
    cinfo.motionType = MotionType.Fixed
    cinfo.shape      = PhysicsFactory:createBox(Vec3(20, 20, 1))
    cinfo.position   = Vec3(0, 0, -1)
    ground.rb = ground.pc:createRigidBody(cinfo)
    ground.rb:setUserData(ground)
end

Events.Update:registerListener(function(dt)
    DebugRenderer:drawOrigin()
end)
