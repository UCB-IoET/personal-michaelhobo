require ("cord")
require ("storm")
require("starterShield")

up_button = storm.io.D10
down_button = storm.io.D9
set_button = storm.io.D11 -- set the 
one_degree = 1
delta_degree = 1 * one_degree
function init()
	storm.io.set_mode(storm.io.INPUT, down_button)
	storm.io.set_mode(storm.io.INPUT, up_button)
	storm.io.set_mode(storm.io.INPUT, set_button)
	storm.io.set_pull(storm.io.PULL_UP, storm.io.D9)
	storm.io.set_pull(storm.io.PULL_UP, storm.io.D10)
	storm.io.set_pull(storm.io.PULL_UP, storm.io.D11)
	good_temp = 0
	LED.start()
	storm.io.watch_all(storm.io.FALLING, up_button, function() good_temp += delta_degree end)
	storm.io.watch_all(storm.io.FALLING, down_button, function() good_temp -= delta_degree end)
	
end

init()

cord.enter_loop()
