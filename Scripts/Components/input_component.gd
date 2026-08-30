class_name InputComponent extends Node

var input_dir : Vector2



func update() -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
