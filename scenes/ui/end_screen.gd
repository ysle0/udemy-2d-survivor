extends CanvasLayer
class_name VictoryScreen

@onready var restart_button: Button = %RestartButton
@onready var quit_button: Button = %QuitButton

func _ready():
	get_tree().paused = true

	self.restart_button.pressed.connect(on_restart_button_pressed)
	self.quit_button.pressed.connect(on_quit_button_pressed)


func on_restart_button_pressed():
	print("on_restart_button_pressed")

	var tree := get_tree()
	tree.paused = false
	# replace current scene with the specificed scene file
	tree.change_scene_to_file("res://scenes/main/main.tscn")


func on_quit_button_pressed():
	print("on_quit_button_pressed")

	var tree := get_tree()
	tree.paused = false
	tree.quit()