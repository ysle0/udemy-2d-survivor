extends Node

@export var sword_ability: PackedScene

var player: Node2D

func _ready():
	self.player = get_tree().get_first_node_in_group("player") as Node2D
	if self.player == null:
		return

	$Timer.timeout.connect(self.on_timer_timeout)


func on_timer_timeout():
	var sword_instance = sword_ability.instantiate() as Node2D

	self.player.get_parent().add_child(sword_instance)
	sword_instance.global_position = self.player.global_position
