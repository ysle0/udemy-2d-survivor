extends CanvasLayer
class_name UpgradeScreen


@export var upgrade_card_scene: PackedScene

@onready var card_container: HBoxContainer = $%CardContainer


func set_ability_upgrade(upgrades: Array[AbilityUpgrade]):
    for upgrade in upgrades:
        var card_instance := upgrade_card_scene.instantiate() as AbilityUpgradeCard
        card_container.add_child(card_instance)
        card_instance.set_ability_upgrade(upgrade)