require("serialization_functions")

call = {["buzzer"] = {["documentation"]="buzzer", ["arguments"]={[0]="1"}}}
call_str = serialize_table(call)
print("call_str:" .. call_str)
buzzer = function(state) print("state is now " .. state) end
_G["buzzer"](table.unpack({[0]="1"}, 0))
--[[for str in string.gmatch(call_str, "{[^}]+}") do
	call_func(string.sub(str, 2, -2))
end]]--
