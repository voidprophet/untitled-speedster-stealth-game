class_name TimeSlowComponent extends Node

var shift
var display_speed 
@export var speed_bar: ProgressBar  

func tick(delta: float) -> void:
	if shift:
		Engine.time_scale -= 0.01
	elif Engine.time_scale < 1.0:
		Engine.time_scale += 0.01
	Engine.time_scale = clamp(Engine.time_scale, 0.001, 1.0)
	
	display_speed = 1/Engine.time_scale * 10
	speed_bar.value = clamp(display_speed,0, 100) 
	
