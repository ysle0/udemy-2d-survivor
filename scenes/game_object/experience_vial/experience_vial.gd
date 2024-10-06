extends Node2D

@onready var area2d := $Area2D as Area2D
@export var experience_amount := 1.0

func _ready():
	area2d.area_entered.connect(on_area_entered)


func on_area_entered(other_area: Area2D):
	queue_free()