require("storm")
local svc_manifest = {
	id="MESH",
	svc_s
}

a_socket = storm.net.udpsocket(1525, function(payload, from, port) print(payload) end)

local msg = storm.mp.pack(svc_manifest)
storm.os.invokePeriodically(5*storm.os.SECOND, function()
	storm.net.sendto(a_socket, msg, "ff02::1", 1525)
end)

function svc_stdout(from_ip, from_port, msg)
  print (string.format("[STDOUT] (ip=%s, port=%d) %s", from_ip, from_port, msg))
end

sh = require("stormsh")
sh.start()
cord.enter_loop()
