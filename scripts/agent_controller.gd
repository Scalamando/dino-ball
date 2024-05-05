extends Node2D
class_name AgentController

@export var dino : DinoController
@export var ball : BeachBall
@export var area : CollisionShape2D

@onready var area_rect = Rect2(area.global_position - area.shape.size/2, area.shape.size)

func _physics_process(_delta):
	if(in_area(ball.target)):
		if dino.position.distance_to(ball.target) > 3.0:
			dino.direction = dino.position.direction_to(ball.target)
		else:
			dino.direction = Vector2.ZERO
	else:
		if dino.position.distance_to(area.position) > 3.0:
			dino.direction = dino.position.direction_to(area.position)
		else:
			dino.direction = Vector2.ZERO

func in_area(p: Vector2):
	return area_rect.has_point(p)
