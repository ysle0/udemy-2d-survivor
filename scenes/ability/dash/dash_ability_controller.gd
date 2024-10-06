class_name DashAbilityController
extends Node

@export var dash_power := 10.0
@export var cooldown_time_in_sec := 3.0
@export var cooldown_reduction_in_sec := 1.0

@onready var cooldown_timer := (%Timer as Timer)

signal on_cooldown

func _ready() -> void:
	assert(self.cooldown_time_in_sec > 0.0, "cooldown time must be bigger than 0.0")
	assert(self.cooldown_reduction_in_sec > 0.0, "cooldown reduction must be bigger than 0.0")


func _process(delta: float) -> void:
	var current_dash_power := self.perform_dash_or_cooldown()
	if current_dash_power > 0.0:
		self.on_cooldown.emit()
	pass


func perform_dash_or_cooldown() -> float:
	if not self.cooldown_timer.is_stopped():
		self.current_dash_power -= self.dash_power_reduction_in_sec
		return 0.0

	if not Input.is_action_pressed("dash"):
		self.current_dash_power -= self.dash_power_reduction_in_sec
		return 0.0

	self.cooldown_timer.start(self.cooldown_time_in_sec)

	return self.dash_power

func apply_dash_power(target_velocity: Vector2) -> Vector2:
	if dash_power <= 0.0:
		return target_velocity

	var applied_target_velocity = target_velocity * self.dash_power
	return applied_target_velocity
