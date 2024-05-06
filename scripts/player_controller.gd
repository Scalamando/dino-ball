extends Node2D
class_name PlayerController

@export var dino_controller : DinoController

func _physics_process(_delta):
	dino_controller.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	dino_controller.sprinting = Input.is_action_pressed("sprint")
