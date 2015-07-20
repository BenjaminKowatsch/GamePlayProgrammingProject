function createCamera(guid,viewtarget,camOffset)
		
		local cam = GameObjectManager:createGameObject(guid)
		cam.cc = cam:createCameraComponent()
		cam.cc:setPosition(Vec3(0,0,0))
		cam.cc:setViewTarget(viewtarget)
		cam.cc:setState(ComponentState.Active)
		cam.pc = cam:createPhysicsComponent()
		local cinfo = RigidBodyCInfo()
		cinfo.shape = PhysicsFactory:createSphere(2.5)
		cinfo.motionType = MotionType.Dynamic
		cinfo.mass = 50.0
		cinfo.gravityFactor = 0
		cinfo.restitution = 0.0
		cinfo.position = viewtarget:getWorldPosition():add(camOffset)
		cinfo.friction = 0.0
		cinfo.maxLinearVelocity = 3000
		cinfo.linearDamping = 5
		cinfo.collisionFilterInfo = 0x2
		cam.rb = cam.pc:createRigidBody(cinfo)
		--custom attributes
		cam.viewTarget = viewtarget
		cam.camOffset = camOffset
		cam.minLength = camOffset:length()
		cam.tiltSpeed = 80
		cam.tiltAngle = 0
		cam.maxTiltAngle = 30
		cam.newCamPos = cam.rb:getPosition()
		cam.moveSpeed = 600
		cam.zOffset = 0
		cam.yaw = 0
		
		cam.update = function (self,elapsedTime,move,zoom)
			-- set zoom
			if(zoom~=0) then
				local newoffset = self.camOffset:add(self.camOffset:normalized():mulScalar(-zoom*30))
				if(self.minLength<=newoffset:length()) then
					self.camOffset = newoffset
				end
			end
			-- tilt camera
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
			
			--if(InputHandler:isPressed(Key.Up) or InputHandler:isPressed(Key.Down)) then
			--	if(InputHandler:isPressed(Key.Up) and (self.zOffset + 1*elapsedTime)< 10 ) then
			--		self.zOffset = self.zOffset + 1*elapsedTime
			--		elseif (InputHandler:isPressed(Key.Down) and -10<(self.zOffset - 1*elapsedTime) ) then
			--		self.zOffset = self.zOffset - 1*elapsedTime
			--	end
			--else
			--	self.zOffset = self.zOffset - self.zOffset*elapsedTime
			--end
			--cam.camOffset = cam.camOffset+Vec3(0,0,self.zOffset)
			
			if(InputHandler:isPressed(Key.Up) or InputHandler:isPressed(Key.Down)) then
				if(InputHandler:isPressed(Key.Up)) then
					self.zOffset = self.zOffset-150*elapsedTime
					cam.camOffset.z = cam.camOffset.z +50*elapsedTime
				elseif (InputHandler:isPressed(Key.Down))then
					self.zOffset = self.zOffset+150*elapsedTime
					cam.camOffset.z = cam.camOffset.z -50*elapsedTime
				end
			else
				--if(self.zOffset<-0.2) then
				--	self.zOffset = self.zOffset+60*elapsedTime
				--elseif (self.zOffset>0.2) then
				--	self.zOffset = self.zOffset-60*elapsedTime
				--end
			end
			local q = Quaternion(cam.cc:getRightDirection(), self.zOffset)
			cam.cc:setViewDirection(q:toMat3():mulVec3(cam.cc:getViewDirection()))
			
			-- calculate cameraimpulse and relative controls
			local camViewTargetDiff = cam.viewTarget:getPosition()-cam.rb:getPosition()
			local relativeControlsAngle = -angleBetweenVec2(Vec2(camViewTargetDiff.x,camViewTargetDiff.y),Vec2(0,1))
			local z = Quaternion(Vec3(0.0, 0.0, 1.0), relativeControlsAngle)
			local moveVector3Rot = z:toMat3():mulVec3(Vec3(move.x,move.y,0))

			local viewTargetVel = cam.viewTarget.rb:getLinearVelocity()
			
			if(move:length() > 0) then
				local offsetAngle = angleBetweenVec2(Vec2(-self.camOffset.x,-self.camOffset.y),Vec2(viewTargetVel.x,viewTargetVel.y))
				local q = Quaternion(Vec3(0.0, 0.0, 1.0), offsetAngle)
				self.camOffset = q:toMat3():mulVec3(self.camOffset)		
			end
			
			self.newCamPos = cam.viewTarget:getPosition()+self.camOffset
			self.rb:applyLinearImpulse((self.newCamPos-cam.rb:getPosition()):mulScalar(elapsedTime*self.moveSpeed*(1+move:length())))
			--self.cc:setViewTarget(cam.viewTarget)
			return moveVector3Rot
		end
		
		--cam.rb.setUserData(cam)	
	
	return cam		
end