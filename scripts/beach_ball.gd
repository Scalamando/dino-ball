class_name BeachBall extends RigidBody2D

signal changed_target
signal touched_ground

@export var velocity : float = 70.0
@export var MIN_TRAVEL_TIME_MSEC = 1750

@export_group("Cosmetic")
@export var MAX_RAND_ANGULAR_VELOCITY = 5.0
@export var GROUND_SHADOW_OFFSET = Vector2(0, 2.0)
@export var ARC_HEIGHT : float = 60.0

var origin : Vector2 = Vector2.ZERO
var target : Vector2 = Vector2.ZERO
var ground_position : Vector2 = Vector2.ZERO

var travel_time_msec : int = 0.0
var last_hit_msec : int = 0
var progress: float = 0.0

var reset_next_tick : bool = false

@onready var ball_sprite = $BallSprite
@onready var shadow_sprite = $ShadowSprite
@onready var collision_shape = $CollisionShape2D

func set_target(new_target: Vector2):
	origin = position
	target = new_target
	travel_time_msec = max(MIN_TRAVEL_TIME_MSEC, (origin.distance_to(target) / velocity) * 1000)
	last_hit_msec = Time.get_ticks_msec()
	angular_velocity = randf_range(-PI, PI) * MAX_RAND_ANGULAR_VELOCITY
	changed_target.emit(target)

func reset():
	reset_next_tick = true
	origin = Vector2.ZERO
	target = Vector2.ZERO
	ground_position = Vector2.ZERO
	travel_time_msec = 0.0
	last_hit_msec = 0
	progress = 0.0

func _integrate_forces(state):
	if reset_next_tick:
		position = Vector2.ZERO
		angular_velocity = 0.0
		reset_next_tick = false

	if target == Vector2.ZERO:
		return
	
	progress = min(float(Time.get_ticks_msec() - last_hit_msec) / travel_time_msec, 1)
	ground_position = lerp(origin, target, _inv_par(progress))
	
	var height = _calc_height(progress) * ARC_HEIGHT
	
	if abs(height) > 10:
		collision_shape.set_deferred("disabled", true)
	else:
		collision_shape.set_deferred("disabled", false)
	
	position = ground_position + Vector2(0, height)

	if progress == 1:
		_on_ground_hit()

func _process(delta):
	shadow_sprite.transform.origin = ground_position + GROUND_SHADOW_OFFSET
	shadow_sprite.modulate.a = 1.0 + 0.8 * _calc_height(progress)
	var scale = 1.0 + 0.5 * _calc_height(progress)
	shadow_sprite.scale = Vector2(scale, scale)

func _on_ground_hit():
	angular_damp = 3.0
	touched_ground.emit()

func _inv_par(x):
	return -(x - 1) ** 2 + 1

func _calc_height(x: float):
	return (2 * x - 1) ** 2 - 1
