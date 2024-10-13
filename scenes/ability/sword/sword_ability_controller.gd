class_name SwordAbilityController
extends Node

@export var max_detect_range: float = 150.0
@export var sword_ability: PackedScene
@export var damage := 5

@onready var timer := $Timer as Timer


var player: Node2D
var base_wait_time: float


var detect_range: float:
	get: return max_detect_range * max_detect_range


func _ready():
	self.player = get_tree().get_first_node_in_group("player") as Node2D
	if self.player == null:
		return

	base_wait_time = timer.wait_time
	timer.timeout.connect(self.on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)


func on_timer_timeout():
	var player_pos := self.player.global_position
	var enemies := get_tree().get_nodes_in_group("enemy")
	if enemies.size() == 0:
		return

	enemies = enemies.filter(func(enemy: Node2D):
		var dist := enemy.global_position.distance_squared_to(player_pos)
		return dist <= self.detect_range
	)
	if enemies.size() == 0:
		return

	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var dist_a := a.global_position.distance_squared_to(player_pos)
		var dist_b := b.global_position.distance_squared_to(player_pos)
		return dist_a < dist_b
	)
	var target_enemy = enemies[0]

	var sword_instance := sword_ability.instantiate() as SwordAbility

	var foreground_layer := get_tree().get_first_node_in_group("foreground_layer")
	foreground_layer.add_child(sword_instance)

	# self.player.get_parent().add_child(sword_instance)
	sword_instance.hitbox_component.damage = self.damage

	var rndpos_in_circle = Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
	sword_instance.global_position = target_enemy.global_position + rndpos_in_circle

	var enemy_dir: Vector2 = target_enemy.global_position - sword_instance.global_position
	sword_instance.rotation = enemy_dir.angle()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id != "sword_rate":
		return

	var upgrade_quantity := current_upgrades["sword_rate"]["quantity"] as int
	timer.wait_time = base_wait_time - (base_wait_time * .1 * upgrade_quantity)
	timer.start()

	print(timer.wait_time)
