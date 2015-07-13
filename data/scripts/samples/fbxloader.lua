
include("utils/physicsWorld.lua")
include("utils/stateMachine.lua")
include("utils/freeCamera.lua")

-- PhysicsDebugView
PhysicsSystem:setDebugDrawingEnabled(true)

freeCam.cc:setPosition(Vec3(0,-130,30))

do
	thModel = GameObjectManager:createGameObject("thModel")

	-- render component
	thModel.render = thModel:createRenderComponent()
	thModel.render:setPath("data/models/barbarian/barbarian.thModel")
	thModel.render:setScale(Vec3(0.5, 0.5, 0.5))
	thModel:setPosition(Vec3(100,0,0))
	thModel.animation = thModel:createAnimationComponent()
	thModel.animation:setSkeletonFile("data/animations/Barbarian/Barbarian.hkt")
	thModel.animation:setSkinFile("data/animations/Barbarian/Barbarian.hkt")
	thModel.animation:addAnimationFile("Idle", "data/animations/Barbarian/Barbarian_Idle.hkt")
	thModel.animation:addAnimationFile("Walk", "data/animations/Barbarian/Barbarian_Walk.hkt")
	thModel.animation:addAnimationFile("Run", "data/animations/Barbarian/Barbarian_Run.hkt")
	thModel.animation:addAnimationFile("Attack", "data/animations/Barbarian/Barbarian_Attack.hkt")

	fbxModelStatic = GameObjectManager:createGameObject("fbxModelStatic")

	-- render component
	fbxModelStatic.render = fbxModelStatic:createRenderComponent()
	fbxModelStatic.render:setPath("data/models/lego/legoStatic.fbx")
	fbxModelStatic.render:setScale(Vec3(2, 2, 2))
	fbxModelStatic:setPosition(Vec3(-50,0,0))

	fbxModelAnimation = GameObjectManager:createGameObject("fbxModelAnimation")
	-- render component
	fbxModelAnimation.render = fbxModelAnimation:createRenderComponent()
	fbxModelAnimation.render:setPath("data/models/lego/lego.fbx")
	fbxModelAnimation.render:setScale(Vec3(2, 2, 2))
	fbxModelAnimation:setPosition(Vec3(-100,0,0))
	fbxModelAnimation.animation = fbxModelAnimation:createAnimationComponent()
	fbxModelAnimation.animation:setSkeletonFile("data/models/lego/Lego_Walk.hkt")
	fbxModelAnimation.animation:setSkinFile("data/models/lego/Lego_Walk.hkt")
	fbxModelAnimation.animation:addAnimationFile("Idle", "data/models/lego/Lego_Walk.hkt")

	fbxModel = GameObjectManager:createGameObject("fbxModel")

	-- render component
	fbxModel.render = fbxModel:createRenderComponent()
	fbxModel.render:setPath("data/models/barbarian/barbarian.fbx")
	fbxModel.render:setScale(Vec3(0.5, 0.5, 0.5))
	fbxModel:setPosition(Vec3(0,0,0))
	fbxModel.animation = fbxModel:createAnimationComponent()
	fbxModel.animation:setSkeletonFile("data/animations/Barbarian/Barbarian.hkt")
	fbxModel.animation:setSkinFile("data/animations/Barbarian/Barbarian.hkt")
	fbxModel.animation:addAnimationFile("Idle", "data/animations/Barbarian/Barbarian_Idle.hkt")
	fbxModel.animation:addAnimationFile("Walk", "data/animations/Barbarian/Barbarian_Walk.hkt")
	fbxModel.animation:addAnimationFile("Run", "data/animations/Barbarian/Barbarian_Run.hkt")
	fbxModel.animation:addAnimationFile("Attack", "data/animations/Barbarian/Barbarian_Attack.hkt")

	--GameObjectManager:createGameObject("sponza"):createRenderComponent():setPath("data/sponza/sponza.fbx")
end
