extends Node
class_name AxeAbilityController

@export var axe_ability_scene: PackedScene

@onready var timer: Timer = $Timer

var player: Player

func _ready():
    self.player = get_tree().get_first_node_in_group("player") as Player
    if self.player == null:
        return

    self.timer.timeout.connect(self.spawn_axe)


func spawn_axe():
    var axe_instance := self.axe_ability_scene.instantiate() as AxeAbility

