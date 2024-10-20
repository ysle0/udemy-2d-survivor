extends Node

const SPAWN_RADIUS := 330
const SPAWN_INTERVAL_DECREASE := 0.1
const SPAWN_INTERVAL_TIME_SEGMENT := 12
const TERRAIN_PHYSICS_LAYER := 1 << 0

@export var spawn_interval: float = 1.0
@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: ArenaTimeManager

@onready var timer: Timer = $Timer

var player: Player

var _base_spawn_time = 0

var get_spawn_interval:
	get:
		return SPAWN_INTERVAL_DECREASE / SPAWN_INTERVAL_TIME_SEGMENT

func _ready():
	assert(basic_enemy_scene != null)
	_base_spawn_time = self.timer.wait_time

	self.player = get_tree().get_first_node_in_group("player") as Player

	self.timer \
		.timeout \
		.connect(self.spawn)

	self.arena_time_manager \
		.arena_difficulty_increased \
		.connect(decrease_spawn_interval)


func spawn():
	self.timer.start()
	if player == null:
		return

	var enemy := self.basic_enemy_scene.instantiate() as Node2D
	var entities_layer := get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy)

	enemy.global_position = self.get_spawn_pos()


func decrease_spawn_interval(arena_difficulty: int):
	var time_off = self.get_spawn_interval * arena_difficulty
	time_off = minf(time_off, 0.7)
	print("time off: ", time_off)

	self.timer.wait_time = self._base_spawn_time - time_off


func get_spawn_pos() -> Vector2:
	if self.player == null:
		return Vector2.ZERO

	var spawn_pos := Vector2.ZERO
	var rnd_dir := Vector2.UP.rotated(randf_range(0, TAU))
	for i in 4:
		var rnd_pos_in_circle := rnd_dir * SPAWN_RADIUS
		spawn_pos = player.global_position + rnd_pos_in_circle

		if self.is_not_collded_in_terrain(spawn_pos):
			break

		rnd_dir = rnd_dir.rotated(deg_to_rad(90))

	return spawn_pos


func is_not_collded_in_terrain(spawn_pos: Vector2) -> bool:
	var raycast_query_params := \
		PhysicsRayQueryParameters2D.create(
			self.player.global_position,
			spawn_pos,
			self.TERRAIN_PHYSICS_LAYER
		)

	var raycast_result = get_tree() \
		.root \
		.world_2d.direct_space_state \
		.intersect_ray(raycast_query_params)

	return raycast_result.is_empty()
