class_name StaminaComponent extends Node

signal regenerating
signal regenerated
signal depleting
signal depleted 

@export var MAX_AMOUNT : float = 1.0
@export var REGENERATION_RATE : float = 0.25
@export var REGENERATION_COOLDOWN : float = 1.0

var stamina : float = MAX_AMOUNT
var last_usage : int = 0
var using : bool = false

func use(amount):
	using = true
	if stamina > 0:
		last_usage = Time.get_ticks_msec()
		stamina -= amount 
		if stamina < 0:
			depleted.emit()
			stamina = 0
		else:
			depleting.emit()

func is_depleted():
	return stamina == 0

func is_full():
	return stamina == MAX_AMOUNT
	
func is_regenerating():
	var time_since_use = Time.get_ticks_msec() - last_usage
	var after_regen_cooldown = time_since_use > REGENERATION_COOLDOWN * 1000
	return after_regen_cooldown and stamina < MAX_AMOUNT

func is_depleting():
	return using

func _physics_process(delta):
	if not using:
		if is_regenerating():
			stamina += delta
			if stamina > MAX_AMOUNT:
				regenerated.emit()
				stamina = MAX_AMOUNT
			else:
				regenerating.emit()
	using = false
