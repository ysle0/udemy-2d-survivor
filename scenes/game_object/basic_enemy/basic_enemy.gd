extends CharacterBody2D

const MAX_SPEED: int = 40
const MIN_DISTANCE_TO_PLAYER: float = 4.5 * 4.5

var player: Node2D

@onready var health_component := $HealthComponent as HealthComponent


func _ready():
	var tree = get_tree()
	if !tree.has_group("player"):
		push_error("no player group found")
		return

	self.player = get_tree().get_first_node_in_group("player")


func _process(_delta: float):
	if !self.check_distance_between_player(MIN_DISTANCE_TO_PLAYER):
		return

	var dir_to_player: Vector2 = self.get_direction_to_player()
	velocity = dir_to_player * MAX_SPEED
	move_and_slide()


func get_direction_to_player() -> Vector2:
	if self.player != null:
		return (self.player.global_position - global_position).normalized()
	return Vector2.ZERO


func check_distance_between_player(min_distance: float) -> bool:
	if self.player == null:
		return false

	var distance_to_player = global_position.distance_to(self.player.global_position)
#	print("distance to player: %s" % distance_to_player)
	return distance_to_player > min_distance
