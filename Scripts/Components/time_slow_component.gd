class_name TimeSlowComponent extends Node

var shift

func tick(delta: float) -> void:
	if shift:
		Engine.time_scale -= 0.01
	elif Engine.time_scale < 1.0:
		Engine.time_scale += 0.01
	Engine.time_scale = clamp(Engine.time_scale, 0.02, 1.0)
