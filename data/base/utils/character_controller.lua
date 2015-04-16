
local errors = {
    invalidInputType = 0
}

-- Extracts an array of functions from \a entry.
-- First return value is the array of functions. This is nil if an error occured.
-- Second return value is an error object. It is nil if there was no error.
local function extractFunction(entry)
    -- If \a entry is a function, it will be the only object in the result table
    if type(entry) == "function" then
        return { entry }
    end
    -- If \a entry is not a function, it must be a table. Otherwise return an error.
    if type(entry) ~= "table" then
        return nil, "Expected either a function or a table, got: " .. type(entry)
    end

    local result = {}
    for _, listener in ipairs(entry) do
        table.insert(result, listener)
    end
    return result
end

--- \param maxDistance Maximum distance to ground.
---        If the ground is further away than that, returns false.
--- \pre ctrl is a character controller, that has a member rigidBody
local function touchesGround(ctrl)
    local halfLen = ctrl.maxDistanceToGround
    local up = ctrl:getGameObject():getUpDirection()

    local ray = RayCastInput()
    ray.filterInfo = ctrl:getRigidBody():getCollisionFilterInfo()
    ray.from       = ctrl:getGameObject():getPosition() +
                     up:mulScalar(halfLen)
    ray.to         = ray.from - up:mulScalar(2 * halfLen)

    local result = PhysicsSystem:getWorld():castRay(ray)
    --if result:hasHit() then
    --    -- Draw green arrow.
    --    DebugRenderer:drawArrow(ray.from, ray.to, Color(0, 1, 0, 1))
    --else
    --    -- Draw red arrow.
    --    DebugRenderer:drawArrow(ray.from, ray.to, Color(1, 0, 0, 1))
    --end
    return result:hasHit()
end

--- \param name The name of the state machine root, i.e. /`name`.
--- \param ctrl The character controller that made this call.
local function createDefaultStateMachine(ctrl, name)
    local stopRunning = false
    local fsm = StateMachine{
        name = name,
        stateMachines = {
            {
                name = "inAir",
                states = {
                    { name = "default" }
                },
                transitions = {
                    { from = "__enter", to = "default" }
                }
            },
            {
                name = "onGround",
                states = {
                    { name = "default" }
                },
                transitions = {
                    { from = "__enter", to = "default" }
                }
            },
        },
        transitions = {
            { from = "__enter", to = "onGround" },
            { from = "inAir", to = "__leave", condition = function() return stopRunning end },
            { from = "onGround", to = "__leave", condition = function() return stopRunning end},
            { from = "onGround", to = "inAir", condition = function() return not touchesGround(ctrl) end},
            { from = "inAir", to = "onGround", condition = function() return touchesGround(ctrl) end},
        }
    }
    -- Provide more convenient access to the inner state machines.
    fsm.inAir    = fsm:getStateMachine("inAir")
    fsm.onGround = fsm:getStateMachine("onGround")
    -- Provide a way to terminate the state machine
    function fsm.terminate()
        stopRunning = true
    end
    fsm:setLoggingEnabled(true)
    return fsm
end

-- #############################################################################
-- ### Public API                                                            ###
-- #############################################################################

-- This function creates and patches a regular RigidBodyCInfo with the given values in \a args.
-- args = {
--     position   = Vec3(0, 0, 0),
--     mass       = 80,  -- 80 kg
--     radius     = 0.5, -- 1 meter diameter
--     height     = 2.0, -- 2 meters
--     motionType = MotionType.Dynamic,
--     shape      = PhysicsFactory:createCapsule(Vec3(0, 0, radius), Vec3(0, 0, height - radius), radius),
--     -- ... and some more ...
-- }
function CharacterRigidBodyCInfo(args)
    local cinfo = RigidBodyCInfo()

    cinfo.position           = args.position           or Vec3(0, 0, 0)
    cinfo.mass               = args.mass               or 80  -- 80 kg
    cinfo.radius             = args.radius             or 0.5 -- 1 meter diameter
    cinfo.height             = args.height             or 2.0 -- 2 meters
    cinfo.motionType         = args.motionType         or MotionType.Dynamic
    cinfo.maxLinearVelocity  = args.maxLinearVelocity  or cinfo.maxLinearVelocity
    cinfo.maxAngularVelocity = args.maxAngularVelocity or cinfo.maxAngularVelocity
    cinfo.gravityFactor      = args.gravityFactor      or 1.5
    cinfo.restitution        = args.restitution        or 0.2
    cinfo.friction           = args.friction           or 1
    cinfo.linearDamping      = args.linearDamping      or 0
    cinfo.angularDamping     = args.angularDamping     or 8
    cinfo.shape              = args.shape or
                               PhysicsFactory:createCapsule(Vec3(0, 0, cinfo.radius),                -- local start
                                                            Vec3(0, 0, cinfo.height - cinfo.radius), -- local end
                                                            cinfo.radius)                            -- capsule radius

    return cinfo
end

-- A table storing all valid key names for a call to CharacterController.
local validKeys = {
    "gameObject",
    "update",
    "maxDistanceToGround"
}
function CharacterController(cinfo)
    local self = {}

    -- Check that all keys in \a cinfo are valid.
    local invalidKeys = checkTableKeys(cinfo, validKeys)
    if not isEmpty(invalidKeys) then
        error("Invalid keys in call to 'CharacterController':\n\t" .. table.concat(invalidKeys, "\n\t"))
    end

    -- Check for the presence of the game object in cinfo.
    local go = cinfo.gameObject
    if not go then
        error("CharacterController needs a gameObject!")
    end
    self.getGameObject = function()
        return go
    end

    -- Check for the presence of a physics component.
    local physicsComponent = go:getPhysicsComponent()
    if isNull(physicsComponent) then
        error("CharacterController needs a gameObject that already has a physics component and a rigid body!")
    end

    -- Check for the presence of a rigid body.
    local rigidBody = physicsComponent:getRigidBody()
    if isNull(rigidBody) then
        error("CharacterController needs a gameObject that already has a physics component and a rigid body!")
    end
    self.getRigidBody = function()
        return rigidBody
    end

    -- Used as the length of ray when checking for collision with the ground
    self.maxDistanceToGround = cinfo.maxDistanceToGround or 0.1

    -- Apply a prismatic constraint to the game object, preventing it from fallign over due to collisions, friction, etc.
    -- The prismatic constraint simply constrains the game object ability to rotate around a single axis only.
    -- The axis chosen is the game object's up-axis.
    Events.PostInitialization:registerListener(function()
        local constraint = {
            type   = ConstraintType.Generic,
            A      = rigidBody,
            pivotA = Vec3(0, 0, 0),
            pivotB = Vec3(0, 0, 0),

            -- Constraints for linear degrees of freedom (dof)
            linear = {
                --dofA     = Vec3(0, 0, 1),  -- dof => Degree Of Freedom
                --dofB     = Vec3(0, 0, 1),  -- dof => Degree Of Freedom
                --dofWorld = Vec3(0, 0, 1),  -- dof => Degree Of Freedom
            },

            -- Constraints for angular degrees of freedom (dof)
            angular = {
                basisA = Vec3(1, 1, 0),
                basisBBodyFrame = true,
            },
        }
        PhysicsSystem:getWorld():addConstraint(PhysicsFactory:createConstraint(constraint))
    end)

    if cinfo.update
    then self.update = cinfo.update
    else self.update = function(go, dt) end
    end

    self.fsm = createDefaultStateMachine(self, cinfo.fsmName or go:getGuid())

    local scriptComponent = go:getScriptComponent()
    if isNull(scriptComponent) then
        scriptComponent = go:createScriptComponent()
    else
        logWarning("Character controller overrides existing script component functions.")
    end

    scriptComponent:setInitializationFunction(function()
        -- Run the state machine
        self.fsm:run()
    end)

    scriptComponent:setUpdateFunction(function(guid, dt)
        self.update(go, dt)
    end)

    scriptComponent:setDestroyFunction(function()
        self.fsm:terminate()
    end)

    return self
end
