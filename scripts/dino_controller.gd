extends CharacterBody2D
class_name DinoController

signal sprint_tank_empty
signal sprint_tank_full
signal sprint_tank_depleting
signal sprint_tank_recharging

signal ball_hit

const SPEED = 60.0
const SPRINT_MULTIPLIER = 2.0
const SPRINT_TANK_MAX = 1.0
const SPRINT_REGEN_COOLDOWN = 1.5

var direction : Vector2 = Vector2.ZERO
var sprinting : bool = false
var sprint_tank_sec : float = SPRINT_TANK_MAX
var last_sprint = 0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func get_sprint_tank():
	return  1 - ((SPRINT_TANK_MAX - sprint_tank_sec) / SPRINT_TANK_MAX)

func _physics_process(delta):
	_tick_sprint(delta)
	
	if animated_sprite.animation == "kick":
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if direction.length() > 0:
		velocity = direction * SPEED
		if sprinting and sprint_tank_sec > 0:
			velocity *= SPRINT_MULTIPLIER
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
	elif not sprinting and Time.get_ticks_msec() - last_sprint > SPRINT_REGEN_COOLDOWN * 1000 and sprint_tank_sec < SPRINT_TANK_MAX:
		sprint_tank_sec = min(sprint_tank_sec + delta, SPRINT_TANK_MAX)
		
		sprint_tank_recharging.emit()
		if sprint_tank_sec >= SPRINT_TANK_MAX:
			sprint_tank_full.emit()

func _process(_delta):
	if animated_sprite.animation == "kick" and animated_sprite.is_playing():
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
