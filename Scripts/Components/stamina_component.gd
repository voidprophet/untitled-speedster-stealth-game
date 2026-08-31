class_name StaminaComponent extends Node

signal depleted
signal low_warning

@export var stamina_bar: ProgressBar
@export var max_stamina: float = 200.0
@export var regen_rate: float = 20.0        # ~7s for a full refill
@export var regen_delay: float = 1.5
@export_range(0.0, 1.0) var low_threshold: float = 0.25

var current_stamina: float = 100.0

var _regen_timer: float = 0.0
var _warned: bool = false

func _ready() -> void:
	current_stamina = max_stamina
	if stamina_bar:
		stamina_bar.min_value = 0.0
		stamina_bar.max_value = max_stamina

## Spend stamina. Returns how much was actually available and taken.
func consume(amount: float) -> float:
	var taken := minf(amount, current_stamina)
	current_stamina -= taken
	_regen_timer = regen_delay

	if current_stamina <= 0.0:
		current_stamina = 0.0
		depleted.emit()
	elif not _warned and current_stamina <= max_stamina * low_threshold:
		_warned = true
		low_warning.emit()

	return taken

func tick(real_delta: float, allow_regen: bool) -> void:
	if allow_regen:
		_regen_timer = maxf(_regen_timer - real_delta, 0.0)
		if _regen_timer <= 0.0 and current_stamina < max_stamina:
			current_stamina = minf(current_stamina + regen_rate * real_delta, max_stamina)

	if current_stamina > max_stamina * low_threshold:
		_warned = false

	if stamina_bar:
		stamina_bar.value = current_stamina

func is_empty() -> bool:
	return current_stamina <= 0.0

func ratio() -> float:
	return current_stamina / max_stamina
