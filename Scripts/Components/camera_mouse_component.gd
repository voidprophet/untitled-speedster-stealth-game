class_name CameraMouseComponent extends Node

@export var phantom_camera_3d: PhantomCamera3D
@onready var body: CharacterBody3D = get_parent() as CharacterBody3D
var mouse_sensitivity: float = 0.1
var min_pitch: float = -89.9
var max_pitch: float = 50
var min_yaw: float = 0
var max_yaw: float = 360

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
		# Get current rotation degrees from Phantom Camera
		var pcam_rotation_degrees: Vector3 = phantom_camera_3d.get_third_person_rotation_degrees()
		
		# Adjust Pitch (X axis) based on vertical mouse movement
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
		
		# Adjust Yaw (Y axis) based on horizontal mouse movement
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
		
		# Apply the new rotation to the Phantom Camera
		phantom_camera_3d.set_third_person_rotation_degrees(pcam_rotation_degrees)
		body.rotation.y = deg_to_rad(pcam_rotation_degrees.y)   
