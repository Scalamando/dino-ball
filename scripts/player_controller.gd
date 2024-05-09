class_name PlayerController extends Node

@export var dino_character : DinoCharacter

func _physics_process(_delta):
	dino_character.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	dino_character.sprinting = Input.is_action_pressed("sprint")
