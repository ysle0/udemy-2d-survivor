extends Node


var current_experience := 0.0


func _ready():
	GameEvents.experience_vial_collected.connect(func(amount: float):
		increment_experience(amount)
	)

func increment_experience(amount: float):
	current_experience += amount
	print("cur exp: %f" % current_experience)