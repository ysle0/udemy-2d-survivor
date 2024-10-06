class_name DashAbilityController
extends Node

@export var cooldown_time_in_sec := 3.0
@export var dash_power := 10.0
@export var dash_power_reduction_in_sec := 1.0

var is_cooldown := true
var current_dash_power := 0.0

@onready var cooldown_timer := get_tree().create_timer(cooldown_time_in_sec)

signal on_cooldown

func _ready() -> void:
	assert(cooldown_time_in_sec > 0.0, "cooldown time must be bigger than 0.0")
	assert(dash_power > 0.0, "dash power must be bigger than 0.0")
	assert(dash_power_reduction_in_sec > 0.0, "cooldown reduction must be bigger than 0.0")

func _process(delta):
	if not is_cooldown:
		current_dash_power = maxf(current_dash_power - dash_power_reduction_in_sec, 0.0)

func _unhandled_input(event: InputEvent):
	if not event.is_action_pressed("dash"):
		return

	if not is_cooldown:
		# current_dash_power -= dash_power_reduction_in_sec
		return

	current_dash_power = dash_power
	# on_cooldown.emit()
	is_cooldown = false

	await get_tree().create_timer(cooldown_time_in_sec).timeout

	is_cooldown = true


func apply_dash_power(target_velocity: Vector2) -> Vector2:
	if current_dash_power <= 0.0:
		return target_velocity

	var applied_target_velocity = target_velocity * current_dash_power
	return applied_target_velocity
