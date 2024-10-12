extends PanelContainer
class_name AbilityUpgradeCard


@onready var name_label := %NameLabel as Label
@onready var description_label := %DescriptionLabel as Label


func set_ability_upgrade(upgrade: AbilityUpgrade):
	name_label.text = upgrade.name
	description_label.text = upgrade.description

