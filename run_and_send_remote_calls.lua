-- require(run_and_send_remote_calls)

-- this function opens a socket that allows you to run remote functions
function open_run_rcvc_call_socket()
   ssock = storm.net.udpsocket(p, 
			       function(payload, from, port)
				  --brd:flash(1)
				  _G[payload]()
				  print(string.format("from %s port %d: %s",from,port,payload))
				  print(storm.net.sendto(ssock, payload, from, cport))
				  brd:flash(1)
			       end)

-- this function opens a socket for you to send client functions, and also returns a pointer to the socket
function open_send_call_socket()

end 



-- this function runs a specific function given a socket, ip, and port 



function send_call(func_name, )



csock = storm.net.udpsocket(cport, 
			    function(payload, from, port)
                               --_G[payload]()
			       --red:flash(3)
			       print (string.format("echo from %s port %d: %s",from,port,payload))
			    end)
