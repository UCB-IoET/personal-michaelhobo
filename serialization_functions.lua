-- format: "id:{func1:documentation:arg1:arg2:...argN}{func2:documentation:arg1:arg2:...argM}..."
id = "1"

--Manually add what functions you would like available to the world into this table. Put the actual name of the function you want called. Arguments use regex.
available = {
	["buzzer"] =	{["documentation"]="This is a buzzer. Arg0 is the state to switch it to. (0 is off, 1 is on)", ["arguments"]={[0]="[01]"}},
	["blue_LED"] =	{["documentation"]="This is a blue LED. Arg0 is the state to switch it to (0 is off, 1 is on)", ["arguments"]={[0]="[01]"}},
	["get_buzzer"] = {["documentation"]="Get the buzzer's state. 0 is off, 1 is on.", ["arguments"]={}},
	["get_id"] = {["documentation"]="Gets the ID of this node.", ["arguments"]={}}
}
len = function(table)
	local count = 0
	if next(table) then
		for k,v in pairs(table) do
			count = count + 1
		end
	end
	return count
end

break_func = function(func_string)
	local count = 0
	local arguments = {}
	local funcname = ""
	for str in string.gmatch(func_string, "[^:]+") do
		if count == 0 then
			funcname = str
		elseif count == 1 then
			documentation = str
		else
			arguments[count - 2] = str
		end
		count = count + 1
	end
	count = count - 2
	return funcname, documentation, arguments, count
end

call_func = function(func_string)
	local funcname, arguments, count = break_func(func_string)
	if count == len(available[funcname]) then
		for key = 0, len(available[funcname]["arguments"])-1 do
			if arguments[key]:match(available[funcname]["arguments"][key]) then
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
		msg = msg .. "{" .. func .. ":" .. table[func]["documentation"]
		for arg_num = 0,len(table[func]["arguments"])-1 do
			msg = msg .. ":" .. table[func]["arguments"][arg_num]
		end
		msg = msg .. "}"
	end
	return msg
end

deserialize_table = function(payload)
	local node_available = {}
	for func_string in string.gmatch(payload, "{[^}]+}") do
		local count = 0
		local funcname, docs, arguments, count = break_func(string.sub(func_string, 2, -2))
		node_available[funcname] = {["documentation"]=docs, ["arguments"]=arguments}
	end
	return node_available
end
