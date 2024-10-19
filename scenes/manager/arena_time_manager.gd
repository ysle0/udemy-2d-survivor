extends Node
class_name ArenaTimeManager

signal arena_difficulty_increased(arena_difficulty: int)

const DIFFICULTY_INTERVAL := 5

@export var end_screen_scene: PackedScene

@onready var timer := %Timer as Timer

var arena_difficulty := 0

func _ready():
	self.timer.timeout.connect(self.on_timer_timeout)


func _process(delta: float):
	var next_time_target := \
		self.timer.wait_time - \
		((self.arena_difficulty + 1) * DIFFICULTY_INTERVAL)

	if self.timer.time_left <= next_time_target:
		self.arena_difficulty += 1
		self.arena_difficulty_increased.emit(self.arena_difficulty)
		print("new arena difficulty: ", self.arena_difficulty)

func get_time_elapsed() -> float:
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen_instance := self.end_screen_scene.instantiate() as EndScreen
	owner.add_child(end_screen_instance)
	end_screen_instance.set_win()
