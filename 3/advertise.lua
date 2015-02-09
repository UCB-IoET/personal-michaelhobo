require("storm")
local svc_manifest = {
	id="MESH",
	svc_stdout={},
}

a_socket = storm.net.udpsocket(50000, function(payload, from, port) print("ack") end)

local msg = storm.mp.pack(svc_manifest)
storm.os.invokePeriodically(5*storm.os.SECOND, function()
	storm.net.sendto(a_socket, msg, "ff02::1", 1525)
end)
pt = function{t, spacing=""} for k, v in pairs(t) do print(k) if type(v)=="table" then pt(v, spacing .. "   ") else print(v) end end end
function svc_stdout(from_ip, from_port, msg)
  print (string.format("[STDOUT] (ip=%s, port=%d) %s", from_ip, from_port, msg))
end

listen_socket = storm.net.udpsocket(1525, function(payload, from, port) pt(storm.mp.unpack(payload)) end)

sh = require("stormsh")
sh.start()
cord.enter_loop()
