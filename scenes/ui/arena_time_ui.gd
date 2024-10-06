extends CanvasLayer

@export var arena_time_manager: Node
@onready var time_elapsed_label := $%Label


func _process(delta):
	if arena_time_manager == null:
		return

	var time_elapsed: float = arena_time_manager.get_time_elapsed()
	set_time_to_label(time_elapsed)


func set_time_to_label(time: float) -> void:
	time_elapsed_label.text = fmt_seconds_to_str(time)


func fmt_seconds_to_str(seconds: float) -> String:
	var minutes := floorf(seconds / 60)
	var remaining_seconds := floorf(seconds - (minutes * 60))

	return "%d:%02d" % [minutes, remaining_seconds]