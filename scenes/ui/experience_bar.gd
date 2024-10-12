extends CanvasLayer

@export var experience_manager: ExperienceManager


func _ready():
	%ProgressBar.value = 0.0
	experience_manager.experience_updated.connect(on_experience_updated)


func on_experience_updated(current_experience: float, target_experience: float):
	var percent := current_experience / target_experience
	%ProgressBar.value = percent
