extends Control
class_name UIGameOver

signal pressed_restart

@export var score_label : Label
@export var restart_button : AreaButton

func set_score(score: int) -> void:
	score_label.text = str(score)

func _ready():
	restart_button.pressed.connect(_on_restart_button_pressed)

func _on_restart_button_pressed():
	pressed_restart.emit()
