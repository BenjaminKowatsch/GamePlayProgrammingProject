function createCamera(guid,viewtarget,camOffset)
		local cam = GameObjectManager:createGameObject(guid)
		cam.cc = cam:createCameraComponent()
		cam.cc:setPosition(Vec3(0,0,0))
		cam.cc:setViewTarget(viewtarget)
		cam.cc:setState(ComponentState.Active)
		cam.pc = cam:createPhysicsComponent()
		local cinfo = RigidBodyCInfo()
		cinfo.shape = PhysicsFactory:createSphere(5)
		cinfo.motionType = MotionType.Dynamic
		cinfo.mass = 50.0
		cinfo.gravityFactor = 0
		cinfo.restitution = 0.0
		cinfo.position = viewtarget:getWorldPosition():add(camOffset)
		cinfo.friction = 0.0
		cinfo.linearDamping = 5
		cinfo.collisionFilterInfo = 0x2
		cam.initialCamOffset = camOffset
		cam.rb = cam.pc:createRigidBody(cinfo)
		--custom attributes
		cam.camRotationSpeed = 40
		cam.viewTarget = viewtarget
		cam.camOffset = camOffset
		cam.minLength = camOffset:length()
		cam.maxZoom = 50
		cam.tiltSpeed = 90
		cam.tiltAngle = 0
		cam.maxTiltAngle = 30
		cam.newCamPos = cam.rb:getPosition()
		cam.moveSpeed = 500
		cam.zOffset = 0
		cam.zOffsetSpeed = 40
		cam.pitchSpeed = 25
		cam.maxPitchAngle = 8
		cam.offsetAngleFactor = 2.5
		cam.zoomSpeed = 300
		
		cam.update = function (self,elapsedTime,move,zoom,rotateCam)
			-- set zoom
			if(zoom~=0) then
				local newoffset = self.camOffset:add(self.camOffset:normalized():mulScalar(-zoom*self.zoomSpeed*elapsedTime))
				if(self.minLength<=newoffset:length() and newoffset:length()< self.minLength+self.maxZoom ) then
					self.camOffset = newoffset
				end
			end
			-- tilt camera
			--	relative to x input
			if (move.x~=0) then
				if(move.x>0 and (self.tiltAngle + self.tiltSpeed*move.x*elapsedTime) < self.maxTiltAngle or 
					move.x<0 and (self.tiltAngle + self.tiltSpeed*move.x*elapsedTime) > -self.maxTiltAngle)  then
					self.tiltAngle = self.tiltAngle + self.tiltSpeed*move.x*elapsedTime			
					self.cc:tilt(self.tiltSpeed*move.x*elapsedTime)
				end
			else
				if(self.tiltAngle>0.5) then
					self.tiltAngle = self.tiltAngle - self.tiltSpeed*0.6*elapsedTime
					self.cc:tilt(-self.tiltSpeed*0.6*elapsedTime)
				elseif(self.tiltAngle<-0.5) then	
					self.tiltAngle = self.tiltAngle + self.tiltSpeed*0.6*elapsedTime
					self.cc:tilt(self.tiltSpeed*0.6*elapsedTime)
				end
			end
			--	relative to y input
			if(move.y~=0) then
				if(move.y>0 and (self.zOffset-self.pitchSpeed*elapsedTime)>-self.maxPitchAngle) then
					self.zOffset = self.zOffset-self.pitchSpeed*elapsedTime
					cam.camOffset.z = cam.camOffset.z -self.zOffsetSpeed*elapsedTime*-gravityFactor
				elseif (move.y<0 and (self.zOffset+self.pitchSpeed*elapsedTime)<self.maxPitchAngle)then
					self.zOffset = self.zOffset+self.pitchSpeed*elapsedTime
					cam.camOffset.z = cam.camOffset.z +self.zOffsetSpeed*elapsedTime*-gravityFactor
				end
			else
				if(self.zOffset<-0.4) then
					self.zOffset = self.zOffset+self.pitchSpeed*elapsedTime
					cam.camOffset.z = cam.camOffset.z +self.zOffsetSpeed*elapsedTime*-gravityFactor
				elseif (self.zOffset>0.4) then
					self.zOffset = self.zOffset-self.pitchSpeed*elapsedTime
					cam.camOffset.z = cam.camOffset.z -self.zOffsetSpeed*elapsedTime*-gravityFactor
				end
			end
			
			-- tilt Background
			local z = Quaternion(cam.cc:getRightDirection(), -self.zOffset*2)
			background.rb:setRotation(Quaternion(cam.cc:getViewDirection(),-cam.tiltAngle) * z)
			
			-- calculate camera impulse and relative controls
			local camViewTargetDiff = cam.viewTarget:getPosition()-cam.rb:getPosition()
			local relativeControlsAngle = -angleBetweenVec2(Vec2(camViewTargetDiff.x,camViewTargetDiff.y),Vec2(0,1))
			local z = Quaternion(Vec3(0.0, 0.0, 1.0), relativeControlsAngle)
			local moveVector3Rot = z:toMat3():mulVec3(Vec3(move.x,move.y,0))

			local viewTargetVel = cam.viewTarget.rb:getLinearVelocity()
			
			local offsetAngle = 0
			if(move:length() > 0) then
				offsetAngle = angleBetweenVec2(Vec2(-self.camOffset.x,-self.camOffset.y),Vec2(viewTargetVel.x,viewTargetVel.y))	
				elseif(rotateCam) then
				offsetAngle = rotateCam*self.camRotationSpeed*-gravityFactor
			end
			local q = Quaternion(Vec3(0.0, 0.0, 1.0), offsetAngle*elapsedTime*self.offsetAngleFactor)
			self.camOffset = q:toMat3():mulVec3(self.camOffset)	
			
			self.newCamPos = cam.viewTarget:getPosition()+self.camOffset

			self.rb:setPosition(self.newCamPos)
			
			-- used for alternativ camera movement
			--self.rb:applyLinearImpulse((self.newCamPos-cam.rb:getPosition()):mulScalar(elapsedTime*self.moveSpeed))
			return moveVector3Rot
		end
		
		--cam.rb.setUserData(cam)	
		
		cam.resetCamOffset = function(self)
			self.camOffset = self.initialCamOffset
		end
	
	return cam		
end