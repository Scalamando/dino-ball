@tool
class_name DinoCharacter extends CharacterBody2D

enum DinoColor { BLUE, GREEN, RED, YELLOW }

@export var speed : float = 60.0
@export var SPRINT_SPEED_MULTIPLIER : float = 1.75
@export var color : DinoColor = DinoColor.BLUE:
	set(value):
		color = value 
		if dino_sprite: dino_sprite.set_color(color)

var direction : Vector2 = Vector2.ZERO
var sprinting : bool = false

@onready var dino_sprite : DinoSprite = $AnimatedSprite2D
@onready var stamina_component = $StaminaComponent

func in_immobile_animation():
	return dino_sprite.animation == "kick" or dino_sprite.animation == "hurt"

func play_animation(name: String):
	dino_sprite.play(name)

func _ready():
	dino_sprite.set_color(color)

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if in_immobile_animation():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if direction.length() > 0:
		velocity = direction * speed
		if sprinting:
			if not stamina_component.is_depleted():
				velocity *= SPRINT_SPEED_MULTIPLIER
			stamina_component.use(delta)
	else:
		velocity = lerp(velocity, Vector2.ZERO, 15 * delta)
	
	move_and_slide()

func _process(_delta):
	if Engine.is_editor_hint():
		return
	
	if in_immobile_animation() and dino_sprite.is_playing():
		return
		
	if velocity.length() > 25.0:
		if velocity.x < 0:
			dino_sprite.flip_h = true
		else:
			dino_sprite.flip_h = false
		
		if sprinting and not stamina_component.is_depleted():
			dino_sprite.play("sprint")
		else:
			dino_sprite.play("run")
	else:
		dino_sprite.play("idle")
