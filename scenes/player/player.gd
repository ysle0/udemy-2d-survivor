extends CharacterBody2D

const MAX_MOVEMENT_SPEED := 200


func _physics_process(delta: float):
	var movement_dir := get_movement_vec2().normalized()
	self.velocity = movement_dir * MAX_MOVEMENT_SPEED
	move_and_slide()


func get_movement_vec2() -> Vector2:
	var move_x := Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var move_y := Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(move_x, move_y)