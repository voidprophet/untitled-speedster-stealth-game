class_name CameraMouseComponent extends Node

@onready var body: CharacterBody3D = get_parent() as CharacterBody3D
@export var sensitivity = 125.0
@export var camera_pivot: Node3D
@export var camera: Camera3D  # Assign your Camera3D node here in the editor

# FOV Settings
@export var base_fov: float = 75.0
@export var max_fov: float = 150.0
@export var max_speed_for_fov: float = 250 # The speed at which FOV hits maximum
@export var fov_smoothing: float = 5     # Higher is snappier, lower is smoother

var current_fov: float = 75.0


func _ready():
	# Ensure mouse is captured to hide cursor and get relative movement
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	# Toggle mouse capture with Escape
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return

	# Only process camera rotation when captured
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		body.rotation.y -= event.relative.x / sensitivity
		camera_pivot.rotation.x -= event.relative.y / sensitivity
		camera_pivot.rotation.x = clamp(camera_pivot.rotation.x, deg_to_rad(-65), deg_to_rad(75))   
