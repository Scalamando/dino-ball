@tool
extends Area2D
class_name AreaButton

signal pressed

@export var text : String = ""

var focus = false

@onready var focus_background = $ActiveBackground
@onready var label = $Label

func _ready():
	label.text = text

func _process(_delta):
	if Engine.is_editor_hint():
		label.text = text

func _on_body_entered(body):
	if body is DinoController:
		focus = true
		focus_background.visible = true

func _on_body_exited(body):
	if body is DinoController:
		focus = false
		focus_background.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and is_visible_in_tree():
		pressed.emit()
