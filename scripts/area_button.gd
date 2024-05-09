@tool
class_name AreaButton extends Area2D

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
	if body is DinoCharacter:
		focus = true
		focus_background.visible = true

func _on_body_exited(body):
	if body is DinoCharacter:
		focus = false
		focus_background.visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and is_visible_in_tree():
		pressed.emit()
