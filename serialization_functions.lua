-- format: "id:{func1:arg1:arg2:...argN}{func2:arg1:arg2:...argM}..."
id = "1"

available = {
	["buzzer"]		=	{[0]="[01]"},
	["blue_LED"]	=	{[0]="[01]"},
}
len = function(table)
	local count = 0
	for _ in pairs(table) do count = count + 1 end
	return count
end

break_func = function(func_string)
	local count = 0
	local arguments = {}
	for str in string.gmatch(func_string, "[^:]+") do
		if count == 0 then
			local funcname = str
		else
			arguments[count - 1] = str
		end
		count = count + 1
	end
	count = count - 1
	return funcname, arguments, count
end

call_func = function(func_string)
	local funcname, local arguments, local count = break_func(func_string)
	if count == len(available[funcname]) then
		for key in 0, len(available[funcname]) - 1 do
			if arguments[key]:match(available[funcname][key]) then
				available[funcname](unpack(args))
				return true
			else
				return false
			end
		end
	end
end

serialize_available = function()
	local msg = id .. ":"
	for func,arg_list in available do
		msg = msg .. "{" .. func
		for arg_num in 0,len(available[func])-1 do
			msg = msg .. ":" .. available[func][arg_num]
		end
		msg = msg .. "}"
	end
	return msg
end

deserialize_available = function(payload)
	local node_available = {}
	for func_string in string.gmatch(payload, "{[^}]+}") do
		local count = 0
		local funcname, local arguments, local count = break_func(func_string)
		node_available[funcname] = arguments
	end
end
