class_name HumanPlayer extends Node2D

signal ball_hit

@onready var dino_character = $DinoCharacter
@onready var player_controller = $PlayerController

func lose():
	dino_character.play_animation("hurt")

func _on_ball_hit_area_body_entered(body):
	dino_character.play_animation("kick")
	ball_hit.emit(self)
