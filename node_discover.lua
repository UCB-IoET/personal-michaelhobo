require "cord" -- scheduler
LED = require("led")
brd = LED:new("GP0")
Button = require("button")
btn1 = Button:new("D9")         -- button 1 on starter shield
blu = LED:new("D2")             -- LEDS on starter shield
grn = LED:new("D3")
red = LED:new("D4")

print("echo test")
brd:flash(4)
p = 9
ipaddr = storm.os.getipaddr()
ipaddrs = string.format("%02x%02x:%02x%02x:%02x%02x:%02x%02x::%02x%02x:%02x%02x:%02x%02x:%02x%02x",
                        ipaddr[0],
                        ipaddr[1],ipaddr[2],ipaddr[3],ipaddr[4],
                        ipaddr[5],ipaddr[6],ipaddr[7],ipaddr[8],
                        ipaddr[9],ipaddr[10],ipaddr[11],ipaddr[12],
                        ipaddr[13],ipaddr[14],ipaddr[15])

print("ip addr", ipaddrs)
print("node id", storm.os.nodeid())
cport = 50000
count = 0

-- create client socket
csock = storm.net.udpsocket(cport,
                            function(payload, from, port)
                               print (string.format("echo from %s port %d: %s",from,port,payload))
                            end)
table = {}

delFromTable = function(id)
     table[id] = nil
end

-- create node model 
node = function() 
     ssock = storm.net.udpsocket(p,
                               function(payload, from, port)
				  table[from] = deserialize_table(payload)
			    	  storm.os.invokeLater(5*storm.os.MINUTE, delFromTable, from)
                                  --print (string.format("from %s port %d: %s",from,port,payload))
				  --print(storm.net.sendto(ssock, payload, from, cport))
                               end)
     storm.os.invokePeriodically(storm.os.MINUTE, storm.net.sendto(ssock, "I'm here!", "ff02::1", p))

-- enable a shell
sh = require "stormsh"
sh.start()
cord.enter_loop() -- start event/sleep loop


