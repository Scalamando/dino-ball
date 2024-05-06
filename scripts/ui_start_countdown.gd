extends Control
class_name UIStartCountdown

signal finished

@export var animation_player : AnimationPlayer

func play() -> void:
	animation_player.play("start_game")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start_game":
		finished.emit()
