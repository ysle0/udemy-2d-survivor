extends CharacterBody2D

const MAX_MOVEMENT_SPEED := 125
const ACCELATION_SMOOTHING := 15

var colliding_body_count: int = 0

func _ready():
	%CollisionArea2D.body_entered.connect(on_body_entered)
	%CollisionArea2D.body_exited.connect(on_body_exited)
	%DamageIntervalTimer.timeout.connect(on_damage_interval_timer_timeout)


func _process(delta: float):
	var movement_dir := get_movement_vec2().normalized()
	var target_velocity := movement_dir * self.MAX_MOVEMENT_SPEED
	target_velocity = %DashAbilityController.apply_dash_power(target_velocity)

	var weight := 1 - exp(-delta * self.ACCELATION_SMOOTHING)
	var next_velocity := self.velocity.lerp(target_velocity, weight)
	self.velocity = next_velocity

	move_and_slide()


func get_movement_vec2() -> Vector2:
	var move_x := \
		Input.get_action_strength("move_right") \
	  - Input.get_action_strength("move_left")
	var move_y := \
	    Input.get_action_strength("move_down") \
	  - Input.get_action_strength("move_up")

	return Vector2(move_x, move_y)


func on_body_entered(other_body: Node):
	print("other_body entered", other_body.name)
	self.colliding_body_count += 1
	self.check_deal_damage()
	pass


func on_body_exited(other_body: Node):
	print("other body exited", other_body.name)
	self.colliding_body_count -= 1
	pass


func check_deal_damage():
	if self.colliding_body_count == 0 or \
		not %DamageIntervalTimer.is_stopped():
		return

	%HealthComponent.take_damage(1.0)
	%DamageIntervalTimer.start()
	print("current health: ", %HealthComponent.current_health)


func on_damage_interval_timer_timeout():
	self.check_deal_damage()