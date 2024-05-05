extends Node2D
class_name PlayerController

@export var dino : DinoController

func _physics_process(_delta):
	dino.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	dino.sprinting = Input.is_action_pressed("sprint")
