extends Node
class_name HealthComponent

signal died
@export var max_health: float = 10

@onready var current_health := max_health


func damage(damage_amount: float):
	current_health = maxf(current_health - damage_amount, 0.0)
	Callable(check_death).call_deferred()


func check_death():
	if current_health == 0.0:
		died.emit()
		owner.queue_free()

