local svc_manifest = {id=”MESH”}              -- why ATeam?
local msg = storm.mp.pack(svc_manifest)
storm.os.invokePeriodically(5*storm.os.SECOND, function()
	storm.net.sendto(a_socket, msg, “ff02::1”, 1525)
end)

