extends Node


signal experience_vial_collected(amount: float)
signal ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary)


func emit_experience_vial_collected(amount: float):
	experience_vial_collected.emit(amount)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrade: Dictionary):
	ability_upgrade_added.emit(upgrade, current_upgrade)