class_name MovementComponent extends Node

@onready var body: CharacterBody3D = get_parent() as CharacterBody3D

var speed: float = 8.0
var gravity: float = 20.0
@export_range(0.0, 1.0) var slowmo_compensation: float = 1.0

var input_dir: Vector2
var movement_dir: Vector3

func tick(delta: float) -> void:
	if not body:
		return

	movement_dir = body.global_basis * Vector3(input_dir.x, 0, input_dir.y)

	var compensation := lerpf(1.0, 1.0 / Engine.time_scale, slowmo_compensation)

	body.velocity.x = movement_dir.x * speed * compensation
	body.velocity.z = movement_dir.z * speed * compensation

	if body.is_on_floor():
		body.velocity.y = 0.0
	else:
		body.velocity.y -= gravity * delta

	body.move_and_slide()
