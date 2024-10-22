extends Node
class_name AxeAbilityController

@export var axe_ability_scene: PackedScene
@export var damage: float = 10.0

@onready var timer: Timer = $Timer

var player: Player

func _ready():
    self.player = get_tree().get_first_node_in_group("player") as Player
    if self.player == null:
        return

    self.timer.timeout.connect(self.spawn_axe)


func spawn_axe():
    var foreground = get_tree() \
        .get_first_node_in_group("foreground_layer") as Node2D
    if foreground == null:
        return

    var axe_instance := self.axe_ability_scene.instantiate() as AxeAbility
    foreground.add_child(axe_instance)

    axe_instance.global_position = self.player.global_position
    axe_instance.hitbox_component.damage = self.damage
