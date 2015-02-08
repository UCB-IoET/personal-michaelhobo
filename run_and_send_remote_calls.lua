require("serial") 
shield = require("starter")
require "cord" -- scheduler / fiber library
LED = require("led")
brd = LED:new("GP0")
require("storm")

-- require(run_and_send_remote_calls)

available = {
	["LED_on"] =	{["documentation"]="Turn on LED. First argument is string for color.", ["arguments"]={[0]="%s"}},
	["LED_off"] =	{["documentation"]="Turn off LED. First argument is string for color.", ["arguments"]={[0]="%s"}},
}

-- this function opens a socket that allows you to run remote functions
function open_run_rcvd_call_socket()
   p = p or 7
   cport = cport or 49152
   ssock = storm.net.udpsocket(p, 
			       function(payload, from, port)
				  print("Running received function: %s", payload)
			          call_func(payload) 
				  --brd:flash(1)
				  --print(string.format("from %s port %d: %s",from,port,payload))
				  storm.net.sendto(ssock, payload, from, cport)
				  --brd:flash(1)
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

-- this function runs a specific function given a socket, ip, and port
-- func name and parameters should be of the form: "func1:documentation:arg1:arg2:...argN"
function send_call(sock,str, ip, port)
	storm.net.sendto(sock, str, ip, p) 
end

shield.LED.start()
function LED_on(color)
	shield.LED.on(color)
end 

function LED_off(color)
	shield.LED.off(color)
end 

shield.LED.on("green")

open_run_rcvd_call_socket()

sh = require "stormsh"
sh.start()

cord.enter_loop() -- start event/sleep loop

