extends Node
class_name ArenaTimeManager

@export var end_screen_scene: PackedScene

@onready var timer := %Timer as Timer

func _ready():
	self.timer.timeout.connect(self.on_timer_timeout)


func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	print("on_timer_timeout> overwinning de spel!")
	var end_screen_instance := \
		self.end_screen_scene.instantiate() as VictoryScreen
	owner.add_child(end_screen_instance)
