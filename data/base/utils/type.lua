-- allow custom type flags
-- uses __builtins (which is not a lua standard, its defined in data/base/utils/builtins.lua)

function type(anything)
	local builtinType = __builtins.type(anything)
	if anything and builtinType == "table" and anything.__type then
		return anything.__type
	end
	return builtinType
end

-- If \a something is not a table, or something does not have a isNull member function
-- an error is raised. Otherwise the result of \a something:isNull() is returned.
function isNull(something)
    if type(something) ~= "table" or not something.isNull then
        error("Attempt to call isNull() for an invalid type!")
    end
    return something:isNull()
end
