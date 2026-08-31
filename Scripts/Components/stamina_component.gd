class_name StaminaComponent extends Node

var shift
var max_stamina := 100
var current_stamina := 100
var scaling_factor := 0.01
@export var stamina_bar: ProgressBar  

func tick(delta: float) -> void:
	if shift:
		current_stamina -= scaling_factor * 1/Engine.time_scale
	elif current_stamina < max_stamina:
		current_stamina += scaling_factor * 100
		
	current_stamina = clamp(current_stamina, 0, max_stamina)
	stamina_bar.value = current_stamina
	
	Log.pr(current_stamina)
