require("discovery")
require("storm")
require("cord")
shield = require("starter")

make_available("set_red1_led", "sets red1 LED", {[0]="[01]"})
make_available("set_red_led", "sets red LED", {[0]="[01]"})

node("blue-green")

set_red1_led = function(state)
	if state == "1" then
		shield.LED.on("red2")
	elseif state == "0" then
		shield.LED.off("red2")
	end
end

set_red2_led = function(state)
	if state == "1" then
		shield.LED.on("red")
	elseif state == "0" then
		shield.LED.off("red")
	end
end

