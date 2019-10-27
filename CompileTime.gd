extends Node

var compile_time := 0.0

var start_time := 0.0
var end_time := 0.0


func get_time() -> float:
	
	return end_time - start_time

func start():
	start_time = OS.get_system_time_msecs()
	print(start_time)

func stop():
	end_time = OS.get_system_time_msecs()
	print(end_time)




