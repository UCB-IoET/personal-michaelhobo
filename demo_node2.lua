require("discovery")
require("storm")
require("cord")
shield = require("starter")

make_available("set_blue_led", "sets blue LED", {[0]="[01]"})
make_available("set_green_led", "sets green LED", {[0]="[01]"})

node("blue-green")

set_blue_led = function(state)
	if state == "1" then
		shield.LED.on("blue")
	elseif state == "0" then
		shield.LED.off("blue")
	end
end

set_green_led = function(state)
	if state == "1" then
		shield.LED.on("green")
	elseif state == "0" then
		shield.LED.off("green")
	end
end

send_call("red-red2", "set_red_led", {[0]="1"})
