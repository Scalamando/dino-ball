extends Node2D

@onready var min_window_width : int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var min_window_height : int = ProjectSettings.get_setting("display/window/size/viewport_height")

func _ready():
	get_window().min_size = Vector2(min_window_width, min_window_height)
