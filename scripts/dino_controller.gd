extends CharacterBody2D
class_name DinoController

signal sprint_tank_empty
signal sprint_tank_full
signal sprint_tank_depleting
signal sprint_tank_recharging

signal ball_hit

@export var SPEED : float = 60.0
@export_group("Sprinting", "SPRINT_")
@export var SPRINT_SPEED_MULTIPLIER : float = 2.0
@export var SPRINT_TANK_SIZE_SEC : float = 1.0
@export var SPRINT_REGEN_COOLDOWN : float = 1.5

var direction : Vector2 = Vector2.ZERO
var sprinting : bool = false
var sprint_tank_sec : float = SPRINT_TANK_SIZE_SEC
var last_sprint = 0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func get_sprint_tank():
	return 1 - ((SPRINT_TANK_SIZE_SEC - sprint_tank_sec) / SPRINT_TANK_SIZE_SEC)

func lose():
	animated_sprite.play("hurt")

func _physics_process(delta):
	_tick_sprint(delta)
	
	if _in_immobile_animation():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if direction.length() > 0:
		velocity = direction * SPEED
		if sprinting and sprint_tank_sec > 0:
			velocity *= SPRINT_SPEED_MULTIPLIER
	else:
		velocity = lerp(velocity, Vector2.ZERO, 15 * delta)
	
	move_and_slide()

func _tick_sprint(delta):
	if sprinting and sprint_tank_sec > 0:
		last_sprint = Time.get_ticks_msec()
		sprint_tank_sec = max(sprint_tank_sec - delta, 0)
		
		sprint_tank_depleting.emit()
		if sprint_tank_sec == 0:
			sprint_tank_empty.emit()
	elif not sprinting and Time.get_ticks_msec() - last_sprint > SPRINT_REGEN_COOLDOWN * 1000 and sprint_tank_sec < SPRINT_TANK_SIZE_SEC:
		sprint_tank_sec = min(sprint_tank_sec + delta, SPRINT_TANK_SIZE_SEC)
		
		sprint_tank_recharging.emit()
		if sprint_tank_sec >= SPRINT_TANK_SIZE_SEC:
			sprint_tank_full.emit()

func _in_immobile_animation():
	return animated_sprite.animation == "kick" or animated_sprite.animation == "hurt"

func _process(_delta):
	if _in_immobile_animation() and animated_sprite.is_playing():
		return
		
	if velocity.length() > 25.0:
		if velocity.x < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
		
		if sprinting and sprint_tank_sec > 0:
			animated_sprite.play("sprint")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("idle")

func _on_ball_hit_area_body_entered(body):
	animated_sprite.play("kick")
	ball_hit.emit(self)
