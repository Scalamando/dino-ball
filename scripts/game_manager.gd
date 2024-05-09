class_name GameManager extends Node

@export_group("Game Logic")
@export var player_area : CollisionShape2D
@export var agent_area : CollisionShape2D
@export var player : HumanPlayer 
@export var ai : AIPlayer 
@export var beach_ball : BeachBall

@export_group("UI", "ui_")
@export var ui_game_over : UIGameOver
@export var ui_start_menu : UIStartMenu
@export var ui_start_countdown : UIStartCountdown

var active_player
var score : int = 0
var started : bool = false

func _ready():
	player.ready.connect(_on_player_ready)
	ai.ready.connect(_on_agent_ready)
	beach_ball.ready.connect(_on_beach_ball_ready)
	ui_game_over.pressed_restart.connect(_on_restart)
	ui_start_menu.pressed_start.connect(_on_start_countdown)
	ui_start_countdown.finished.connect(_on_start)

func _on_player_ready():
	player.ball_hit.connect(_on_player_ball_hit)
	active_player = player
	
func _on_agent_ready():
	ai.ball_hit.connect(_on_ai_ball_hit)

func _on_beach_ball_ready():
	beach_ball.touched_ground.connect(_on_beach_ball_touched_ground)

func _on_player_ball_hit(player: HumanPlayer):
	if active_player == player:
		score += 1
		beach_ball.set_target(rand_in_area(agent_area))
		active_player = ai 

func _on_ai_ball_hit(ai: AIPlayer):
	if active_player == ai:
		beach_ball.set_target(rand_in_area(player_area))
		active_player = player

func _on_beach_ball_touched_ground():
	if not started or not active_player:
		return
	
	active_player.lose()
	active_player = null
	started = false
	ai.active = false
	ui_game_over.set_score(score)
	ui_game_over.visible = true

func _on_start_countdown():
	beach_ball.reset()
	active_player = null 
	ui_start_menu.visible = false
	ui_start_countdown.play()

func _on_start():
	active_player = player 
	ai.active = true
	beach_ball.set_target(rand_in_area(player_area))
	started = true

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


