extends Camera2D

var player: Node2D
var target_position = Vector2.ZERO


func _ready():
	make_current()

	player = get_tree().get_first_node_in_group("player") as Node2D


func _process(delta: float):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 3))


func acquire_target():
	if player:
		target_position = player.global_position