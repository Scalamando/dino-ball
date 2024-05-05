extends Sprite2D

@export var dino_controller : DinoController

func _ready():
	dino_controller.sprint_tank_depleting.connect(_show)
	dino_controller.sprint_tank_full.connect(_start_hide_countdown)

func _process(_delta):
	frame = floor((1 - dino_controller.get_sprint_tank()) * 4)

func _show():
	visible = true
	$SprintMeterTimer.stop()

func _start_hide_countdown():
	$SprintMeterTimer.start()

func _on_sprint_meter_timer_timeout():
	visible = false
