extends CharacterBody2D

const MAX_MOVEMENT_SPEED := 125
const ACCELATION_SMOOTHING := 15

@onready var dash_ability := %DashAbilityController as DashAbilityController


func _process(delta: float):
	var movement_dir := get_movement_vec2().normalized()
	var target_velocity := movement_dir * self.MAX_MOVEMENT_SPEED
	target_velocity = self.dash_ability.apply_dash_power(target_velocity)

	var weight := 1 - exp(-delta * self.ACCELATION_SMOOTHING)
	var next_velocity := self.velocity.lerp(target_velocity, weight)
	self.velocity = next_velocity

	move_and_slide()


func get_movement_vec2() -> Vector2:
	var move_x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var move_y := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(move_x, move_y)
