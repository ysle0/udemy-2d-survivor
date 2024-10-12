extends Node
class_name ExperienceManager


signal experience_updated(current_experience: float, target_experience: float)

const TARGET_EXPERIENCE_GROWTH := 1.5

var current_experience := 0.0
var target_experience := 5.0
var current_level := 1


func _ready():
    GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_experience(amount: float):
    current_experience = minf(current_experience + amount, target_experience)
    experience_updated.emit(current_experience, target_experience)
    print("cur exp: %f" % current_experience)

    if current_experience >= target_experience:
        current_level += 1
        target_experience *= TARGET_EXPERIENCE_GROWTH
        current_experience = 0.0
        experience_updated.emit(current_experience, target_experience)


func on_experience_vial_collected(amount: float):
    increment_experience(amount)
