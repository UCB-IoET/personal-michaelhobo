-- format: "id:{func1:arg1:arg2:...argN}{func2:arg1:arg2:...argM}..."
id = "1"

available = {
	["buzzer"]		=	{"This is a buzzer. Arg0 is the state to switch it to. (0 is off, 1 is on)", {[0]="[01]"}},
	["blue_LED"]	=	{"This is a blue LED. Arg0 is the state to switch it to (0 is off, 1 is on)", {[0]="[01]"}},
	["get_buzzer"] = {"Get the buzzer's state. 0 is off, 1 is on.", {}},
}

break_func = function(func_string)
	local count = 0
	local arguments = {}
	local funcname = ""
	for str in string.gmatch(func_string, "[^:]+") do
		if count == 0 then
			funcname = str
		else
			arguments[count - 1] = str
		end
		count = count + 1
	end
	count = count - 1
	print(funcname)
	return funcname, arguments, count
end

call_func = function(func_string)
	local funcname, arguments, count = break_func(func_string)
	if count == #available[funcname] then
		for key = 0, #available[funcname] do
			if arguments[key]:match(available[funcname][key]) then
				_G[funcname](unpack(arguments))
				return true
			else
				return false
			end
		end
	end
end

serialize_available = function()
	serialize_table(available)
end

serialize_table = function(table)
	local msg = id .. ":"
	for func,arg_list in pairs(table) do
		msg = msg .. "{" .. func
		for arg_num = 0,#table[func] do
			msg = msg .. ":" .. table[func][arg_num]
		end
		msg = msg .. "}"
	end
	return msg
end

deserialize_available = function(payload)
	local node_available = {}
	for func_string in string.gmatch(payload, "{[^}]+}") do
		local count = 0
		local funcname, arguments, count = break_func(string.sub(func_string, 2, -2))
		node_available[funcname] = arguments
	end
	return node_available
end
