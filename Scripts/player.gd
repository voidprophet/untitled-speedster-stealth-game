extends CharacterBody3D

@onready var movement_component: MovementComponent = %MovementComponent
@onready var input_component: InputComponent = %InputComponent

func _physics_process(delta: float) -> void:
	input_component.update()

	movement_component.input_dir = input_component.input_dir
	movement_component.tick(delta)
