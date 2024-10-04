extends Node

@export var max_detect_range: float = 150.0
@export var sword_ability: PackedScene

var player: Node2D


func _ready():
	print("_ready()>")
	self.player = get_tree().get_first_node_in_group("player") as Node2D
	if self.player == null:
		return
	$Timer.timeout.connect(self.on_timer_timeout)


func on_timer_timeout():
	print("on_timer_timeout()>")
	
	var player_position: Vector2 = self.player.global_position
	var enemies: Array[Node]     = get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return

	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player_position) <= pow(self.max_detect_range, 2)
	)
	if enemies.size() == 0:
		return


	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var dist_a = a.global_position.distance_squared_to(player_position)
		var dist_b = b.global_position.distance_squared_to(player_position)
		return dist_a < dist_b
	)

	var sword_instance: Node2D = sword_ability.instantiate() as Node2D
	self.player.get_parent().add_child(sword_instance)
	sword_instance.global_position = enemies[0].global_position
