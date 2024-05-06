extends Control
class_name UIStartMenu

signal pressed_start

@export var start_button : AreaButton

func display() -> void:
	visible = true

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	pressed_start.emit()

