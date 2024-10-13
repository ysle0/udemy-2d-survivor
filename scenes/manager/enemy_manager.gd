extends Node

const SPAWN_RADIUS := 330

@export var spawn_interval: float = 1.0
@export var basic_enemy_scene: PackedScene

func _ready():
	assert(basic_enemy_scene != null)
	$Timer.timeout.connect(self.on_timer_timeout)


func on_timer_timeout():
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
