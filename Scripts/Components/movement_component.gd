class_name MovementComponent extends Node

@onready var body: CharacterBody3D = get_parent() as CharacterBody3D

var speed := 5.0
var input_dir : Vector2
var movement_dir : Vector3

func tick(delta: float) -> void:
	if not body:
		return
	
	movement_dir = body.transform.basis * Vector3(input_dir.x, 0, input_dir.y) 
	
	body.velocity.x = movement_dir.x * speed * 1/Engine.time_scale
	body.velocity.z = movement_dir.z * speed * 1/Engine.time_scale
	
	body.move_and_slide()
