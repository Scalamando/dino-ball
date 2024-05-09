class_name SprintMeter extends Sprite2D

@export var stamina_component : StaminaComponent 

func _ready():
	stamina_component.depleting.connect(_show)
	stamina_component.regenerated.connect(_start_hide_countdown)

func _process(_delta):
	var stamina_percent = stamina_component.stamina / stamina_component.MAX_AMOUNT
	frame = floor((1 - stamina_percent) * 4)

func _show():
	visible = true
	$SprintMeterTimer.stop()

func _start_hide_countdown():
	$SprintMeterTimer.start()

func _on_sprint_meter_timer_timeout():
	visible = false
