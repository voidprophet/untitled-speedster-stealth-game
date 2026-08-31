class_name EnemySightComponent extends Node

signal player_spotted
signal player_lost

@export var eye: Node3D
@export var player: CharacterBody3D
@export var vision_bar: ProgressBar

@export var view_distance: float = 20.0
@export var view_angle_deg: float = 60.0
@export var sight_mask: int = 0xFFFFFFFF   # must include player AND walls
@export var check_interval: float = 0.1

@export var fill_rate: float = 40.0
@export var decay_rate: float = 15.0
@export var alarm_floor: float = 25.0
@export var debug: bool = false

var detection: float = 0.0

var _seen: bool = false
var _next_check: float = 0.0
var _alarmed: bool = false
var _floor: float = 0.0
var _debug_timer: float = 0.0

func _ready() -> void:
	if not eye:
		push_error("EnemySightComponent: 'eye' not assigned")
		set_process(false)
		return
	if not player:
		player = get_tree().get_first_node_in_group("Player")
	if not player:
		push_error("EnemySightComponent: no player found (assign it, or add the player to group 'player')")
		set_process(false)
		return
	if vision_bar:
		vision_bar.min_value = 0.0
		vision_bar.max_value = 100.0

func _process(delta: float) -> void:
	_next_check -= delta
	if _next_check <= 0.0:
		_next_check = check_interval
		_seen = _can_see_player()

	detection += (fill_rate if _seen else -decay_rate) * delta
	detection = clampf(detection, _floor, 100.0)

	if not _alarmed and detection >= 100.0:
		_alarmed = true
		_floor = alarm_floor
		player_spotted.emit()
	elif _alarmed and detection <= _floor + 0.01 and not _seen:
		_alarmed = false
		player_lost.emit()

	if vision_bar:
		vision_bar.value = detection

	if debug:
		_debug_timer -= delta
		if _debug_timer <= 0.0:
			_debug_timer = 0.5
			print("seen=%s detection=%.0f" % [_seen, detection])

func _can_see_player() -> bool:
	var origin := eye.global_position
	var to_player := player.global_position - origin
	var dist := to_player.length()

	if dist > view_distance:
		if debug: print("  fail: distance %.1f > %.1f" % [dist, view_distance])
		return false

	var forward := -eye.global_basis.z
	var angle := rad_to_deg(forward.angle_to(to_player.normalized()))
	if angle > view_angle_deg:
		if debug: print("  fail: angle %.1f > %.1f" % [angle, view_angle_deg])
		return false

	var space := eye.get_world_3d().direct_space_state
	var exclude: Array[RID] = []
	var owner_body := get_parent() as CollisionObject3D
	if owner_body:
		exclude.append(owner_body.get_rid())

	for offset in [Vector3(0, 0.2, 0), Vector3(0, 1.0, 0), Vector3(0, 1.7, 0)]:
		var q := PhysicsRayQueryParameters3D.create(
			origin, player.global_position + offset, sight_mask)
		q.exclude = exclude
		var hit := space.intersect_ray(q)
		if not hit.is_empty() and hit.collider == player:
			return true

	if debug: print("  fail: occluded (in range, in cone)")
	return false
