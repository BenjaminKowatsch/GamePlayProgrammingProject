include("SuperMonkeyBall/helper.lua")
include("SuperMonkeyBall/ball.lua")
include("SuperMonkeyBall/camera.lua")


function createPlayer()
	local player = {}
	player.ball = createBall(Vec3(0,0,14))
	--used for alternative camera movement 
	--player.capsule = createCollisionCapsule("capsule",Vec3(0,0,-250),Vec3(0,0,500),65)
	--player.capsule:setPosition(player.ball:getPosition())
	player.displayTime = false
	player.timeCounter = 0
	player.cam = createCamera("camera",player.ball,Vec3(0,-50,24))
	
	player.update= function(self,elapsedTime)	
		--display time counter
		if self.displayTime then
			if (self.timeCounter>=0) then			
				DebugRenderer:printText(Vec2(0.5,-0.5), "Remaining time: ".. string.format("%5.2f", self.timeCounter).." s")
				self.timeCounter  = self.timeCounter - elapsedTime
			else
				DebugRenderer:printText(Vec2(0.5,-0.5), "Time is up!")
				player.timeCounter = 0
				self.displayTime = true
			end
		end
		-- keyboard player input
		local move = Vec2(0, 0)
		if (InputHandler:isPressed(Key.A)) then move.x = - 1 end
		if (InputHandler:isPressed(Key.D)) then move.x = 1 end
		if (InputHandler:isPressed(Key.W)) then move.y = 1 end
		if (InputHandler:isPressed(Key.S)) then move.y = -1 end
		move = move:normalized()
		-- gamepad player input
		local gamepad = InputHandler:gamepad(0)
		local leftStick = gamepad:leftStick()
		local rightStick = gamepad:rightStick()
		-- mouse player input
		local mouseDelta = InputHandler:getMouseDelta()
		move = move + leftStick
		move.x = move.x * -gravityFactor
		local zoom = mouseDelta.z + rightStick.y	
		local rotateCam = -rightStick.x + -mouseDelta.x
		-- jump
		if(InputHandler:wasTriggered(Key.Space) or bit32.btest(gamepad:buttonsTriggered(), Button.A)) then
			self.ball:jump()
		end
		-- update camera and receive relative movement input
		local moveVector3Rot = self.cam:update(elapsedTime,move,zoom,rotateCam)
		
		self.ball:update(elapsedTime,Vec2(moveVector3Rot.x,moveVector3Rot.y))
		--used for alternative camera movement
		--self.capsule:update((self.ball:getPosition()-self.capsule.rb:getPosition()),elapsedTime)
	end

	player.reset = function(self,t,dT)
		self.timeCounter = t 
		self.displayTime = dT
		self.ball:reset()
		self.cam:resetCamOffset()
		setGravity(-1)
	end
	
	return player
end