@tool
class_name DinoSprite extends AnimatedSprite2D

@export var skins : Array[DinoSkin]

func set_color(color_index : int) -> void:
	sprite_frames = skins[color_index].sprite_frames
