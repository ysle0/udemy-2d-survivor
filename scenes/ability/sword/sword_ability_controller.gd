extends Node

@export var max_detect_range: float = 150.0
@export var sword_ability: PackedScene

var player: Node2D


func _ready():
	self.player = get_tree().get_first_node_in_group("player") as Node2D
	if self.player == null:
		return
	$Timer.timeout.connect(self.on_timer_timeout)


func get_valid_detect_range() -> float:
	return self.max_detect_range * self.max_detect_range


func on_timer_timeout():
	var player_pos := self.player.global_position
	var enemies := get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return

	enemies = enemies.filter(func(enemy: Node2D):
		var valid_range := self.get_valid_detect_range()
		var dist := enemy.global_position.distance_squared_to(player_pos)
		return dist <= valid_range
	)
	if enemies.size() == 0:
		return

	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var dist_a := a.global_position.distance_squared_to(player_pos)
		var dist_b := b.global_position.distance_squared_to(player_pos)
		return dist_a < dist_b
	)
	var target_enemy = enemies[0]

	var sword_instance: Node2D = sword_ability.instantiate()
	self.player.get_parent().add_child(sword_instance)

	var rndpos_in_circle = Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	sword_instance.global_position = target_enemy.global_position + rndpos_in_circle

	var enemy_dir: Vector2 = target_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_dir.angle()
