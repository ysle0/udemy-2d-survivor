extends Node
class_name UpgradeManager

@export var upgrade_pool: Array[AbilityUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades := {
	"test": "hello"
}

func _ready():
	experience_manager.level_up.connect(on_level_up)


func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade := current_upgrades.has(upgrade.id)
	if not has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	if upgrade.max_quantity > 0:
		var current_quantity: int = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func(pool_upgrade):
				return pool_upgrade.id != upgrade.id
			)

	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)


func pick_upgrade():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades := self.upgrade_pool.duplicate()
	for i in self.upgrade_pool.size():
		var chosen_upgrade := filtered_upgrades.pick_random() as AbilityUpgrade
		if chosen_upgrade == null:
			break

		chosen_upgrades.append(chosen_upgrade)
		filtered_upgrades = filtered_upgrades.filter(func(upgrade: AbilityUpgrade):
				return upgrade.id != chosen_upgrade.id
		)

	return chosen_upgrades


func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)


func on_level_up(new_level: int):
	var upgrade_screen_instance := upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen_instance)

	var chosen_upgrades = self.pick_upgrade()
	upgrade_screen_instance.set_ability_upgrade(
		chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
