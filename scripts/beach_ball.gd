extends RigidBody2D
class_name BeachBall

signal touched_ground

const MIN_TRAVEL_TIME_MSEC = 1750
const GROUND_SHADOW_OFFSET = Vector2(0, 2.0)

var velocity : float = 70.0
var height_mag : float = 60.0

var origin : Vector2 = Vector2.ZERO
var target : Vector2 = Vector2.ZERO
var ground_position : Vector2 = Vector2.ZERO

var travel_time_msec : int = 0.0
var last_hit_msec : int = 0

var progress: float = 0.0

@onready var ball_sprite = $BallSprite
@onready var shadow_sprite = $ShadowSprite
@onready var collision_shape = $CollisionShape2D

func set_target(new_target: Vector2):
	origin = position
	target = new_target
	var distance = origin.distance_to(target)
	travel_time_msec = max(MIN_TRAVEL_TIME_MSEC, (distance / velocity) * 1000)
	last_hit_msec = Time.get_ticks_msec()
	angular_velocity = randf_range(-PI, PI) * 5

func _integrate_forces(state):
	if target == Vector2.ZERO:
		return
	
	progress = min(float(Time.get_ticks_msec() - last_hit_msec) / travel_time_msec, 1)
	ground_position = lerp(origin, target, _inv_par(progress))
	
	var height = _calc_height(progress) * height_mag
	
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
