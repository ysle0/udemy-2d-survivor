extends Node

@onready var timer := %Timer as Timer


func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


