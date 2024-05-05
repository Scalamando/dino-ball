extends Node
class_name GameManager

signal game_over

@export var player_area : CollisionShape2D
@export var opponent_area : CollisionShape2D

@export var player : DinoController
@export var opponent : DinoController

@export var ball : BeachBall

var active_dino : DinoController
var score : int = 0

func _ready():
	player.ball_hit.connect(_on_ball_hit)
	opponent.ball_hit.connect(_on_ball_hit)
	ball.touched_ground.connect(_on_ball_touched_ground)
	active_dino = player
	ball.set_target(rand_in_area(player_area))

func _on_ball_hit(dino: DinoController):
	if dino == active_dino:
		if active_dino == player:
			score += 1
			ball.set_target(rand_in_area(opponent_area))
			active_dino = opponent
		elif active_dino == opponent:
			ball.set_target(rand_in_area(player_area))
			active_dino = player

func _on_ball_touched_ground():
	if active_dino:
		active_dino.lose()
		active_dino = null
	$"../GameOver/ScoreValueLabel".text = str(score)
	$"../GameOver".visible = true

func rand_in_area(area: CollisionShape2D):
	var size_x = area.shape.size.x / 2
	var size_y = area.shape.size.y / 2
	return Vector2(\
		randf_range(-size_x, size_x),\
		randf_range(-size_y, size_y)
	) + area.position

func _on_restart_area_interacted():
	get_tree().reload_current_scene()
