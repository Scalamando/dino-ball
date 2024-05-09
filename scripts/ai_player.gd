class_name AIPlayer extends Node2D

signal ball_hit

@export var beach_ball : BeachBall
@export var navigation_area : CollisionShape2D

@onready var dino_character = $DinoCharacter
@onready var ai_controller = $AIController

var active : bool:
	set(value):
		ai_controller.active = value 
	get:
		return ai_controller.active

func lose():
	dino_character.play_animation("hurt")

func _ready():
	ai_controller.navigation_area = navigation_area 
	beach_ball.changed_target.connect(_on_beach_ball_changed_target)

func _on_beach_ball_changed_target(target: Vector2):
	ai_controller.target = target

func _on_ball_hit_area_body_entered(body):
	dino_character.play_animation("kick")
	ball_hit.emit(self)
