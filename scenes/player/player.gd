extends CharacterBody2D

const MAX_MOVEMENT_SPEED := 125
const ACCELATION_SMOOTHING := 15


func _process(delta: float):
	var movement_dir := get_movement_vec2().normalized()
	var target_velocity := movement_dir * MAX_MOVEMENT_SPEED
	var lerp_weight := 1 - exp(-delta * ACCELATION_SMOOTHING)

	self.velocity = self.velocity.lerp(target_velocity, lerp_weight)

	move_and_slide()


func get_movement_vec2() -> Vector2:
	var move_x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var move_y := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(move_x, move_y)
