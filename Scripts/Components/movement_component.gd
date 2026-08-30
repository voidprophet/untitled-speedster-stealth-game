class_name MovementComponent extends Node

@export var body: CharacterBody3D

var speed := 5.0
var input_dir : Vector2
var movement_dir : Vector3

func tick(delta: float) -> void:
	if not body:
		return
	
	movement_dir = body.transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	
	body.velocity.x = movement_dir.x * speed
	body.velocity.z = movement_dir.z * speed
	
	body.move_and_slide()
