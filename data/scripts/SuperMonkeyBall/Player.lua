include("SuperMonkeyBall/helper.lua")
include("SuperMonkeyBall/ball.lua")
include("SuperMonkeyBall/camera.lua")


function createPlayer()
	local player = {}
	player.ball = createBall()
	--player.capsule = createCollisionCapsule("capsule",Vec3(0,0,-250),Vec3(0,0,500),65)
	--player.capsule:setPosition(player.ball:getPosition())
	player.cam = createCamera("camera",player.ball,Vec3(0,-70,25))
	
	player.update= function(self,elapsedTime)
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
		
		if(InputHandler:wasTriggered(Key.Space) or bit32.btest(gamepad:buttonsTriggered(), Button.A)) then
			self.ball.jump()
		end
		
		local moveVector3Rot = self.cam:update(elapsedTime,move,zoom)
		
		self.ball:update(elapsedTime,Vec2(moveVector3Rot.x,moveVector3Rot.y))
		--self.capsule:update((self.ball:getPosition()-self.capsule.rb:getPosition()),elapsedTime)
	end
	
	return player
end