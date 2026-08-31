class_name CameraMouseComponent extends Node

@onready var body: CharacterBody3D = get_parent() as CharacterBody3D

@export var sensitivity: float = 125.0
@export var camera_pivot: Node3D
@export var min_pitch_deg: float = -65.0
@export var max_pitch_deg: float = 75.0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		body.rotation.y -= event.relative.x / sensitivity
		camera_pivot.rotation.x -= event.relative.y / sensitivity
		camera_pivot.rotation.x = clampf(
			camera_pivot.rotation.x,
			deg_to_rad(min_pitch_deg),
			deg_to_rad(max_pitch_deg))
