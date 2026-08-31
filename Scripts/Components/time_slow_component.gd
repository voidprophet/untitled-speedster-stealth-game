class_name TimeSlowComponent extends Node

signal state_changed(new_state: int)

enum State { IDLE, CHARGING, SUSTAINING, GRACE, COLLAPSING }

@export var stamina: StaminaComponent
@export var speed_bar: ProgressBar

# --- Depth to time scale ---
@export var min_time_scale: float = 0.05
@export var curve_power: float = 1.0

# --- Charging (shift) ---
@export var charge_rate: float = 0.5        # depth/sec; 2s to full
@export var charge_cost: float = 24.0       # stamina/sec at zero depth
@export var charge_cost_ramp: float = 1.5   # multiplier growth with depth

# --- Sustaining ---
@export var sustain_cost: float = 14.0      # stamina/sec at full depth
@export var sustain_power: float = 1.6      # shallow is much cheaper

# --- Braking (ctrl) ---
@export var brake_rate: float = 0.8         # depth/sec shed

# --- Soft landing ---
@export var grace_time: float = 0.6
@export var collapse_time: float = 1.0

# --- Physics rate compensation ---
@export var maintain_physics_rate: bool = true
@export var max_physics_ticks: int = 1200

var shift: bool = false
var brake: bool = false
var slow_amount: float = 0.0
var state: State = State.IDLE

var _base_physics_ticks: int = 60
var _timer: float = 0.0
var _collapse_from: float = 0.0

func _ready() -> void:
	_base_physics_ticks = Engine.physics_ticks_per_second
	if speed_bar:
		speed_bar.min_value = 0.0
		speed_bar.max_value = 100.0

func _exit_tree() -> void:
	Engine.time_scale = 1.0
	Engine.physics_ticks_per_second = _base_physics_ticks

func tick(real_delta: float) -> void:
	#Log.pr(Engine.get_frames_per_second())
	match state:
		State.IDLE:
			if shift and not stamina.is_empty():
				_set_state(State.CHARGING)

		State.CHARGING:
			if not shift:
				_set_state(State.SUSTAINING)
			else:
				var cost_rate := charge_cost * (1.0 + charge_cost_ramp * slow_amount)
				var wanted := cost_rate * real_delta
				var got := stamina.consume(wanted)
				var paid := got / wanted if wanted > 0.0 else 0.0
				slow_amount = minf(slow_amount + charge_rate * real_delta * paid, 1.0)
				if stamina.is_empty():
					_enter_grace()

		State.SUSTAINING:
			if shift and not stamina.is_empty():
				_set_state(State.CHARGING)
			else:
				# Braking sheds depth; cost falls with it automatically
				if brake:
					slow_amount = maxf(slow_amount - brake_rate * real_delta, 0.0)
					if slow_amount <= 0.0:
						_set_state(State.IDLE)

				var rate := sustain_cost * pow(slow_amount, sustain_power)
				stamina.consume(rate * real_delta)
				if stamina.is_empty():
					_enter_grace()

		State.GRACE:
			_timer -= real_delta
			if _timer <= 0.0:
				_collapse_from = slow_amount
				_timer = collapse_time
				_set_state(State.COLLAPSING)

		State.COLLAPSING:
			_timer = maxf(_timer - real_delta, 0.0)
			var t := 1.0 - (_timer / collapse_time)
			slow_amount = _collapse_from * (1.0 - _ease_out(t))
			if _timer <= 0.0:
				slow_amount = 0.0
				_set_state(State.IDLE)

	_apply_time_scale()

	if speed_bar:
		speed_bar.value = slow_amount * 100.0

func can_regen() -> bool:
	return state == State.IDLE

func _enter_grace() -> void:
	_timer = grace_time
	_set_state(State.GRACE)

func _set_state(new_state: State) -> void:
	if state == new_state:
		return
	state = new_state
	state_changed.emit(state)

func _apply_time_scale() -> void:
	var d := pow(slow_amount, curve_power)
	Engine.time_scale = pow(min_time_scale, d)

	if maintain_physics_rate:
		var target := int(_base_physics_ticks / Engine.time_scale)
		Engine.physics_ticks_per_second = mini(target, max_physics_ticks)

func _ease_out(t: float) -> float:
	return 1.0 - pow(1.0 - t, 2.0)
