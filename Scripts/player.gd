extends CharacterBody3D

@onready var movement_component: MovementComponent = %MovementComponent
@onready var input_component: InputComponent = %InputComponent
@onready var camera_mouse_component: CameraMouseComponent = %CameraMouseComponent
@onready var time_slow_component: TimeSlowComponent = %TimeSlowComponent
@onready var stamina_component: StaminaComponent = %StaminaComponent


func _physics_process(delta: float) -> void:
	input_component.update()

	movement_component.input_dir = input_component.input_dir
	time_slow_component.shift = input_component.shift
	stamina_component.shift = input_component.shift
	
	movement_component.tick(delta)
	time_slow_component.tick(delta)
	stamina_component.tick(delta)
	
