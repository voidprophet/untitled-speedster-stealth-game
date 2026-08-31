class_name InputComponent extends Node

var input_dir: Vector2
var shift: bool = false
var brake: bool = false

func update() -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	shift = Input.is_action_pressed("speed_up")
	brake = Input.is_action_pressed("slow_down")
