extends Node
class_name ArenaTimeManager

@export var victory_screen_scene: PackedScene

@onready var timer := %Timer as Timer

func _ready():
	self.timer.timeout.connect(self.on_timer_timeout)


func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	print("on_timer_timeout> overwinning de spel!")
	var victory_screen_instance := \
		self.victory_screen_scene.instantiate() as VictoryScreen
	owner.add_child(victory_screen_instance)
