-- Code to use run_and_send_remote_calls

socket = open_send_call_socket()
p = 7 
ip = "fe80::212:6d02:0:300a"
ip = "ff02::1"

send_call("LED_on:doc:blue", socket, ip, p)
send_call("LED_off:doc:blue", socket, ip, p)
send_call("LED_on:doc:red", socket, ip, p)
