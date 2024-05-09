@tool
class_name DinoSprite extends AnimatedSprite2D

@export var color_sprite_frames : Array[Resource]

func set_color(color_index : int) -> void:
	sprite_frames = color_sprite_frames[color_index]
