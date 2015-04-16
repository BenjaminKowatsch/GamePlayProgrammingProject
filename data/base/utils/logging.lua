local function createMessage(args)
	local message = "Lua: "
	for _,arg in ipairs(args) do
		message = message .. tostring(arg)
	end
	return message
end

function logMessage(...)
	Logging:logMessage(createMessage({...}))
end

function logWarning(...)
	Logging:logWarning(createMessage({...}))
end

function logError(...)
	Logging:logError(createMessage({...}))
end
