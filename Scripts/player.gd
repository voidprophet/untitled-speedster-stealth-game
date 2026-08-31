extends CharacterBody3D

@onready var movement_component: MovementComponent = %MovementComponent
@onready var input_component: InputComponent = %InputComponent
@onready var camera_mouse_component: CameraMouseComponent = %CameraMouseComponent
@onready var time_slow_component: TimeSlowComponent = %TimeSlowComponent
@onready var stamina_component: StaminaComponent = %StaminaComponent

var _steps := 0
var _game_time := 0.0
var _t0 := 0

func _physics_process(delta: float) -> void:
	_steps += 1
	_game_time += delta
	movement_component.input_dir = input_component.input_dir
	movement_component.tick(delta)

func _process(_d: float) -> void:
	var now := Time.get_ticks_msec()
	if now - _t0 >= 1000:
		print("fps=%d real_steps=%d game_secs=%.3f (time_scale %.3f)" % [
			Engine.get_frames_per_second(), _steps, _game_time, Engine.time_scale])
		_steps = 0
		_game_time = 0.0
		_t0 = now
			
			
	var real_delta := _d / Engine.time_scale

	input_component.update()

	time_slow_component.shift = input_component.shift
	time_slow_component.brake = input_component.brake	
	time_slow_component.tick(real_delta)

	stamina_component.tick(real_delta, time_slow_component.can_regen())
	
