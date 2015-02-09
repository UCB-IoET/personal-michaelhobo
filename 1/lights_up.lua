require ("cord")
require ("storm")
shield = require("starter")

leds = ({"blue", "green", "red", "red2"})
on = 2
function init()
	shield.Button.start()
	shield.LED.start()
	shield.LED.on(leds[on])
	shield.Button.when(1, "FALLING", right_light)
	shield.Button.when(2, "FALLING", left_light)
end

function right_light()
	shield.LED.off(leds[on])
	if on > 1 then on = on - 1 end
	shield.LED.on(leds[on])
	shield.Button.when(1, "FALLING", right_light)
	print(on)
end

function left_light()
	shield.LED.off(leds[on])
	if on < 4 then on = on + 1 end
	shield.LED.on(leds[on])
	shield.Button.when(2, "FALLING", left_light)
	print(on)
end

init()

cord.enter_loop()
