extends Node2D
class_name AgentController

@export var dino_controller : DinoController
@export var ball : BeachBall
@export var area : CollisionShape2D

@onready var area_rect = Rect2(area.global_position - area.shape.size/2, area.shape.size)

var active : bool = false

func in_area(p: Vector2):
	return area_rect.has_point(p)

func _physics_process(_delta):
	if active and in_area(ball.target):
		if dino_controller.position.distance_to(ball.target) > 3.0:
			dino_controller.direction = dino_controller.position.direction_to(ball.target)
		else:
			dino_controller.direction = Vector2.ZERO
	else:
		if dino_controller.position.distance_to(area.position) > 3.0:
			dino_controller.direction = dino_controller.position.direction_to(area.position)
		else:
			dino_controller.direction = Vector2.ZERO
