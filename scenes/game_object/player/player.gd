extends CharacterBody2D
class_name Player

const MAX_MOVEMENT_SPEED := 125
const ACCELATION_SMOOTHING := 15

@onready var health_component: HealthComponent = %HealthComponent
@onready var damage_interval_timer: Timer = %DamageIntervalTimer
@onready var collision_area_2d: Area2D = %CollisionArea2D
@onready var dash_ability_controller: DashAbilityController = \
	%DashAbilityController
@onready var health_bar: ProgressBar = %HealthBar
@onready var abilities: Node = $Abilities

var colliding_body_count: int = 0


func _ready():
	self.collision_area_2d.body_entered.connect(on_body_entered)
	self.collision_area_2d.body_exited.connect(on_body_exited)
	self.damage_interval_timer.timeout.connect(
		on_damage_interval_timer_timeout)
	self.health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)

	self.update_health_ui()


func _process(delta: float):
	var movement_dir := get_movement_vec2().normalized()
	var target_velocity := movement_dir * self.MAX_MOVEMENT_SPEED
	target_velocity = self.dash_ability_controller \
		.apply_dash_power(target_velocity)

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
	self.colliding_body_count += 1
	self.check_deal_damage()
	pass


func on_body_exited(other_body: Node):
	self.colliding_body_count -= 1
	pass


func check_deal_damage():
	if self.colliding_body_count == 0 or \
		not self.damage_interval_timer.is_stopped():
		return

	self.health_component.take_damage(1.0)
	self.damage_interval_timer.start()
	# print("current health: ", self.health_component.current_health)


func update_health_ui():
	self.health_bar.value = self.health_component.get_health_percent()


func on_damage_interval_timer_timeout():
	self.check_deal_damage()


func on_health_changed():
	self.update_health_ui()


func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is not Ability:
		return

	var ability := ability_upgrade as Ability
	var ability_controller_instance := ability.ability_controller_scene.instantiate()
	abilities.add_child(ability_controller_instance)


