-- needed for alternative camera movement
function createCollisionCapsule(guid, startPos, endPos, radius)
	local capsule = GameObjectManager:createGameObject(guid)
	capsule.pc = capsule:createPhysicsComponent()
	local cinfo = RigidBodyCInfo()
	cinfo.shape = PhysicsFactory:createCapsule(startPos, endPos, radius)
	cinfo.motionType = MotionType.Keyframed
	cinfo.collisionFilterInfo = 0x2
	capsule.rb = capsule.pc:createRigidBody(cinfo)
	capsule.moveSpeed = 700
	capsule.update = function (self,velocity,elapsedTime)
		capsule.rb:setLinearVelocity(velocity:mulScalar(elapsedTime*self.moveSpeed))
	end
	return capsule
end

function angleBetweenVec2(vector1, vector2)
	local angleRad = math.atan2(vector2.y, vector2.x) - math.atan2(vector1.y, vector1.x)
	local angleDeg = (angleRad/math.pi)*180
	if (angleDeg > 180) then
		angleDeg = angleDeg - 360
	end
	if (angleDeg < -180) then
		angleDeg = angleDeg + 360
	end
	return angleDeg
end