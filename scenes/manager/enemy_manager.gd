extends Node

const SPAWN_RADIUS := 330
const SPAWN_INTERVAL_DECREASE := 0.1
const SPAWN_INTERVAL_TIME_SEGMENT := 12

@export var spawn_interval: float = 1.0
@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer

var _base_spawn_time = 0

var get_spawn_interval:
	get:
		return SPAWN_INTERVAL_DECREASE / SPAWN_INTERVAL_TIME_SEGMENT

func _ready():
	assert(basic_enemy_scene != null)
	_base_spawn_time = self.timer.wait_time

	self.timer.timeout.connect(self.spawn)
	self.arena_time_manager.arena_difficulty_increased.connect(
		decrease_spawn_interval
	)


func spawn():
	self.timer.start()

	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

	var rnd_dir := Vector2.UP.rotated(randf_range(0, TAU))
	var rnd_pos_in_circle := rnd_dir * SPAWN_RADIUS
	var spawn_pos: Vector2 = player.global_position + rnd_pos_in_circle

	var enemy := self.basic_enemy_scene.instantiate() as Node2D

	var entities_layer := get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)
	# get_parent().add_child(enemy)

	enemy.global_position = spawn_pos


func decrease_spawn_interval(arena_difficulty: int):
	var time_off = self.get_spawn_interval * arena_difficulty
	time_off = minf(time_off, 0.7)
	print("time off: ", time_off)

	self.timer.wait_time = self._base_spawn_time - time_off