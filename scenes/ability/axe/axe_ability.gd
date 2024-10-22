extends Node2D
class_name AxeAbility


const MAX_RADIUS := 100

@export_range(-5.0, 5.0) var rotations_from: float = 0.0
@export_range(-5.0, 5.0) var rotations_to: float = 2.0
@export var duration: float = 3.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent


var player: Player
var base_rotation := Vector2.RIGHT


func _ready():
    self.player = get_tree().get_first_node_in_group("player") as Player
    if self.player == null:
        return

    self.base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))

    var tween := super.create_tween()
    tween.tween_method(
        self.tween_method, \
        self.rotations_from, \
        self.rotations_to, \
        self.duration
    )
    tween.tween_callback(self.queue_free)


func tween_method(rotations: float):
    var percent := rotations / 2
    var current_radius := percent * MAX_RADIUS
    var current_direction := self.base_rotation.rotated(rotations * TAU)

    global_position = self.player.global_position + \
        (current_direction * current_radius)
