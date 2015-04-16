
function tostring(anything, typeOverride, arg0)
	if typeOverride == nil then
		return __builtins.tostring(anything)
	end

	if typeOverride == "vec3" then
		return "{"
			.. tostring(anything.x) .. ", "
			.. tostring(anything.y) .. ", "
			.. tostring(anything.z)
			.. "}"
	end

	if typeOverride == "table" then
		local result = "{ "
		for key, value in pairs(anything) do
			key = __builtins.tostring(key)
			value = __builtins.tostring(value)
			result = result .. key .. " = " .. value .. ", "
		end
		return result
	end
end

function string.startsWith(str, start)
	return string.sub(str, 1, string.len(start)) == start
end

function string.endsWith(str, theEnd)
	return theEnd == "" or string.sub(str, -string.len(theEnd)) == theEnd
end
