-- Use the default physics world.
include("utils/physicsWorld.lua")


do
	local cinfo = WorldCInfo()
	cinfo.gravity = Vec3(0,0, -9.81)
	cinfo.worldSize = 2000
	local World = PhysicsFactory:createWorld(cinfo)
	PhysicsSystem:setWorld(world)




end