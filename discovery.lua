require "cord" -- scheduler
require("storm")
ipaddr = storm.os.getipaddr()
	ipaddrs = string.format("%02x%02x:%02x%02x:%02x%02x:%02x%02x::%02x%02x:%02x%02x:%02x%02x:%02x%02x",
			ipaddr[0],
			ipaddr[1],ipaddr[2],ipaddr[3],ipaddr[4],
			ipaddr[5],ipaddr[6],ipaddr[7],ipaddr[8],
			ipaddr[9],ipaddr[10],ipaddr[11],ipaddr[12],
			ipaddr[13],ipaddr[14],ipaddr[15])

print("ip addr", ipaddrs)
print("node id", storm.os.nodeid())

pub_port = 9
priv_port = 50000
count = 0


	-- Initialization Code 
	--Manually add what functions you would like available to the world into this table. Put the actual name of the function you want called. Arguments use regex.
	-- format: "id:{func1:documentation:arg1:arg2:...argN}{func2:documentation:arg1:arg2:...argM}..."

available = {
	["get_id"] = {["documentation"]="Gets the ID of this node.", ["arguments"]={}}
}
table = {}

delFromTable = function(id)
	table[id] = nil
end

show_discovered = function()
end 	
	

	-- Initialize this node for discovery
node = function(ID)
	id = ID
	-- create public socket
	ssock = storm.net.udpsocket(pub_port,
		function(payload, from, port)
				print(payload)
				table[from] = deserialize_table(payload)
        if table [from] == nil then
          table[from] = {["value"]= deserialize_table(payload),["destruct"]= function () 
							storm.os.invokeLater(5*storm.os.SECOND, delFromTable, from)
						end }
        else 
          storm.os.cancel(table[from]["destruct"])
          table[from] = {["value"]= deserialize_table(payload), ["destruct"]= function ()
							storm.os.invokeLater(5*storm.os.SECOND, delFromTable, from)
						end }
				end
			end)

	priv_sock = storm.net.udpsocket(priv_port,
		function(payload, from, port)
				all_good = true
				for str in string.gmatch(payload, "{[^}]+}") do
					all_good = call_func(string.sub(str, 2, -2)) and all_good
				end
			end)
	storm.os.invokePeriodically(storm.os.SECOND, function()
			storm.net.sendto(ssock, serialize_available() , "ff02::1", pub_port)
		end)
end

function make_available(func_name, documentation, arguments)
	available[func_name] = {["documentation"] = documentation, ["arguments"] = arguments}
end

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
	local funcname, documentation, arguments, count = break_func(func_string)
	if count == len(available[funcname]["arguments"]) then
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
	return serialize_table(available)
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

--[[ UNUSED CODE for now
	-- this function opens a socket that allows you to run remote functions
function open_run_rcvd_call_socket()
	p = p or 7
	cport = cport or 49152
ssock = storm.net.udpsocket(p,
		function(payload, from, port)
		print("Running received function: %s", payload)
		call_func(payload)
		storm.net.sendto(ssock, payload, from, cport)
		end)
	end

	-- this function opens a socket for you to send functions as a client, and also returns a pointer to the socket
function open_send_call_socket()
	cport = cport or 49152
csock = storm.net.udpsocket(cport,
		function(payload, from, port)
		print("Socket to send functions calls as client open")
		print (string.format("echo from %s port %d: %s",from,port,payload))
		end)
	return csock
	end 
]]--

	-- this function runs a specific function given a socket, ip, and port
	-- func name and parameters should be of the form: "func1:documentation:arg1:arg2:...argN"
function send_call(ID, func_name, arguments)
	print("call num val..")
	local func_string = func_name
	print("call num val?")
	for arg_key = 0,len(arguments) - 1 do
		print("call num val!")
		func_string = func_string .. ":" .. arguments[arg_key]
		print("call num val T.T")
	end
	--storm.net.sendto(priv_sock, func_string, find_ip(ID), priv_port)
end

function find_ip(ID)
	for k,v in pairs(table) do 
     cur_ID = string.sub(v["value"], string.find(str, "[^:]+"))
     print(cur_ID)
     if cur_ID == ID then 
         return k 
     end 
	end
end
