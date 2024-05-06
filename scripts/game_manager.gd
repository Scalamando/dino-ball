extends Node
class_name GameManager

@export_group("Game Logic")
@export var player_area : CollisionShape2D
@export var agent_area : CollisionShape2D
@export var player : PlayerController
@export var agent : AgentController
@export var ball : BeachBall

@export_group("UI", "ui_")
@export var ui_game_over : UIGameOver
@export var ui_start_menu = UIStartMenu

var active_dino_controller : DinoController
var score : int = 0

func _ready():
	player.ready.connect(_on_player_ready)
	agent.ready.connect(_on_agent_ready)
	ball.ready.connect(_on_ball_ready)
	ui_game_over.pressed_restart.connect(_on_restart)
	ui_start_menu.pressed_start.connect(_on_start)

func _on_player_ready():
	player.dino_controller.ball_hit.connect(_on_player_ball_hit)
	active_dino_controller = player.dino_controller
	
func _on_agent_ready():
	agent.dino_controller.ball_hit.connect(_on_agent_ball_hit)

func _on_ball_ready():
	ball.touched_ground.connect(_on_ball_touched_ground)

func _on_player_ball_hit(dino: DinoController):
	if dino == active_dino_controller:
		score += 1
		ball.set_target(rand_in_area(agent_area))
		active_dino_controller = agent.dino_controller

func _on_agent_ball_hit(dino: DinoController):
	if dino == active_dino_controller:
		ball.set_target(rand_in_area(player_area))
		active_dino_controller = player.dino_controller

func _on_ball_touched_ground():
	if active_dino_controller:
		active_dino_controller.lose()
		active_dino_controller = null
	
	agent.active = false
	ui_game_over.set_score(score)
	ui_game_over.visible = true

func _on_start():
	ui_start_menu.visible = false
	agent.active = true
	ball.set_target(rand_in_area(player_area))

func _on_restart():
	get_tree().reload_current_scene()


# Utilities

func rand_in_area(area: CollisionShape2D):
	var size_x = area.shape.size.x / 2
	var size_y = area.shape.size.y / 2
	return Vector2(\
		randf_range(-size_x, size_x),\
		randf_range(-size_y, size_y)
	) + area.position


