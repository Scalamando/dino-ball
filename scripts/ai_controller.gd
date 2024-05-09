class_name AIController extends Node

@export var dino_character : DinoCharacter

var target : Vector2 
var reachable_rect : Rect2
var navigation_area : CollisionShape2D:
	set(area):
		reachable_rect = Rect2(area.global_position - area.shape.size/2, area.shape.size)
		navigation_area = area

var active : bool = false

func in_area(p: Vector2):
	if reachable_rect:
		return reachable_rect.has_point(p)
	else:
		return false

func _physics_process(_delta):
	dino_character.direction = _get_direction()

func _get_direction():
	if active and in_area(target):
		if dino_character.global_position.distance_to(target) > 3.0:
			return dino_character.global_position.direction_to(target)
	elif navigation_area:
		if dino_character.global_position.distance_to(navigation_area.global_position) > 3.0:
			return dino_character.global_position.direction_to(navigation_area.global_position)
	
	return Vector2.ZERO
