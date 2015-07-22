Goal = {}
Goal.__index = Goal

setmetatable(Goal, {
	__index = PickupBase,
	__call = function(cls,...)
		local self = setmetatable({},cls)
		self:_init(...) -- call constructor
		return self
	end,
})



function Goal:_init(guid,position,cfi,w,h,d)
	PickupBase._init(self,guid,position,cfi,w,h,d) -- super constructor call 
	self.goal = false
end

function Goal:onBeginOverlap(go)
	self.goal = true
end