extends Area2D
class_name Interactable

signal interacted

var active = false
@onready var active_background = $ActiveBackground

func _on_body_entered(body):
	if body is DinoController:
		active = true
		active_background.visible = true

func _on_body_exited(body):
	if body is DinoController:
		active = false
		active_background.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		interacted.emit()
