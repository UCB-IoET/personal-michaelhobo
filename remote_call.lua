--[[
   echo client as server
   currently set up so you should start one or another functionality at the
   stormshell

--]]

shield = require("starter")
require "cord" -- scheduler / fiber library
LED = require("led")
brd = LED:new("GP0")
require("storm")

print("echo test")
brd:flash(4)
p = 7
ipaddr = storm.os.getipaddr()
ipaddrs = string.format("%02x%02x:%02x%02x:%02x%02x:%02x%02x::%02x%02x:%02x%02x:%02x%02x:%02x%02x",
			ipaddr[0],
			ipaddr[1],ipaddr[2],ipaddr[3],ipaddr[4],
			ipaddr[5],ipaddr[6],ipaddr[7],ipaddr[8],	
			ipaddr[9],ipaddr[10],ipaddr[11],ipaddr[12],
			ipaddr[13],ipaddr[14],ipaddr[15])


print("ip addr", ipaddrs)
print("node id", storm.os.nodeid())
cport = 49152

--[[ example of steps:
A device does not typically broadcast its functionality.
It only does so in response to a discovery request from a client. 
Once it receives the request, it returns its function, choices and state.
A different request initiates a change in state.
The server responds by making the change in state and updating its internal parameters. 
]]--

-- create echo server as handler
server = function()
   ssock = storm.net.udpsocket(p, 
			       function(payload, from, port)
				  --brd:flash(1)
				  _G[payload]()
				  print(string.format("from %s port %d: %s",from,port,payload))
				  print(storm.net.sendto(ssock, payload, from, cport))
				  brd:flash(1)
			       end)
end

server()			-- every node runs the echo server

-- client side
Button = require("button")
btn1 = Button:new("D9")		-- button 1 on starter shield
blu = LED:new("D2")		-- LEDS on starter shield
grn = LED:new("D3")
red = LED:new("D4")
count = 0
-- create client socket
csock = storm.net.udpsocket(cport, 
			    function(payload, from, port)
                               --_G[payload]()
			       --red:flash(3)
			       print (string.format("echo from %s port %d: %s",from,port,payload))
			    end)

-- send echo on each button press
client = function()
   --blu:flash(1)
   local msg = "lighton"
   print("send:", msg)
   -- send upd echo to link local all nodes multicast
   storm.net.sendto(csock, msg, "ff02::1", p) 
   count = count + 1
   --grn:flash(1)
end

--[[ button press runs client
btn1:whenever("RISING",function() 
		print("Run client")
		client() 
]]--		      end)

function lighton()
   local state = 0
   return function ()
      if state  == 1 then 
	 print ("blink on", state)
	 shield.LED.on(blue)
	 shield.LED.on(red)
shield.LED.on(green)
      else 
	 print ("blink off", state)
	 shield.LED.off(green)
shield.LED.on(red)
shield.LED.on(blue)
      end
      state=1-state
   end	
end 

   shield.LED.start()
storm.os.invokePeriodically(1*storm.os.SECOND, client)



-- enable a shell
--sh = require "stormsh"
--sh.start()
cord.enter_loop() -- start event/sleep loop
