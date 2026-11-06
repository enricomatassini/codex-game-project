extends Node3D
## Physical table and two moving shoe colliders. All kicks are transferred by
## contacts with the moving soles; no scripted impulse is added to the solver.

signal phase_changed(value: String)
signal return_completed(total: int)
signal missed()

const GRAVITY := 9.81
const TABLE_MASS := 6.0
const REST_Y := 2.15
const SHOE_SIZE := Vector3(0.26, 0.12, 0.42)
const PREP_TIME := 0.24
const PREP_DEPTH := 0.10
const PUSH_TIME := 0.14
const PUSH_ACCELERATION := 22.0
const COMPRESSION_TIME := 0.28
const RECOVERY_TIME := 0.45
const MAX_FOOT_SPEED := 3.4
const MAX_FOOT_ACCELERATION := 30.0

var body: RigidBody3D
var feet_positions: Array[Vector3] = []
var phase: String = "supported"
var returns: int = 0

var _feet: Array[AnimatableBody3D] = []
var _foot_velocities: Array[Vector3] = [Vector3.ZERO, Vector3.ZERO]
var _assistance := true
var _clock := 0.0
var _side := 0
var _rest_height := REST_Y
var _catch_start_y := REST_Y
var _catch_speed := 0.0
var _stable_time := 0.0
var _flight_started := false
var _real_contact := false
var _reset_pending := false
var _launch_pending := false
var _lateral_target := Vector2.ZERO


func _ready() -> void:
	_create_table()
	_create_feet()
	_apply_reset()


func _create_table() -> void:
	body = RigidBody3D.new()
	body.name = "TableBody"
	body.mass = TABLE_MASS
	body.gravity_scale = 1.0
	body.linear_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	body.linear_damp = 0.0
	body.angular_damp_mode = RigidBody3D.DAMP_MODE_REPLACE
	body.angular_damp = 0.0
	body.center_of_mass_mode = RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM
	body.center_of_mass = Vector3(0.0, 0.065, 0.0)
	body.continuous_cd = true
	body.contact_monitor = true
	body.max_contacts_reported = 16
	body.can_sleep = true
	body.collision_layer = 1
	body.collision_mask = 2
	var material := PhysicsMaterial.new()
	material.friction = 0.85
	material.bounce = 0.0
	body.physics_material_override = material
	add_child(body)
	_box(body, Vector3(1.4, 0.10, 1.4), Vector3.ZERO)
	for side in [-1.0, 1.0]:
		_box(body, Vector3(1.265, 0.16, 0.065), Vector3(0.0, 0.12, side * 0.60))
		_box(body, Vector3(0.065, 0.16, 1.265), Vector3(side * 0.60, 0.12, 0.0))
		for depth in [-1.0, 1.0]:
			_box(body, Vector3(0.075, 0.70, 0.075), Vector3(side * 0.58, 0.40, depth * 0.58))


func _create_feet() -> void:
	for index in range(2):
		var foot := AnimatableBody3D.new()
		foot.name = "LeftSole" if index == 0 else "RightSole"
		foot.sync_to_physics = false
		foot.collision_layer = 2
		foot.collision_mask = 1
		var material := PhysicsMaterial.new()
		material.friction = 0.9
		material.bounce = 0.0
		foot.physics_material_override = material
		add_child(foot)
		_box(foot, SHOE_SIZE, Vector3.ZERO)
		_feet.append(foot)
		feet_positions.append(Vector3.ZERO)


func _box(parent: Node3D, size: Vector3, offset: Vector3) -> void:
	var shape := BoxShape3D.new()
	shape.size = size
	var collision := CollisionShape3D.new()
	collision.shape = shape
	collision.position = offset
	parent.add_child(collision)


func set_assistance(enabled: bool) -> void:
	_assistance = enabled


func launch(side: int = 0) -> void:
	# An air tap cannot reach the table or add energy. One pending gesture only.
	if phase != "supported" or _launch_pending or _reset_pending:
		return
	_side = clampi(side, -1, 1)
	_launch_pending = true


func reset() -> void:
	# Reset once at a physics boundary, never from a contact signal callback.
	_reset_pending = true


func _apply_reset() -> void:
	_reset_pending = false
	_launch_pending = false
	returns = 0
	_clock = 0.0
	_stable_time = 0.0
	_flight_started = false
	_real_contact = false
	_lateral_target = Vector2.ZERO
	_foot_velocities = [Vector3.ZERO, Vector3.ZERO]
	for index in range(2):
		_feet[index].position = Vector3(-0.28 if index == 0 else 0.28, REST_Y, 0.10)
		feet_positions[index] = _feet[index].global_position
	body.freeze = false
	body.position = Vector3(0.0, 2.30, 0.0)
	body.rotation = Vector3.ZERO
	body.linear_velocity = Vector3.ZERO
	body.angular_velocity = Vector3.ZERO
	body.sleeping = false
	body.reset_physics_interpolation()
	for foot in _feet:
		foot.reset_physics_interpolation()
	_set_phase("supported")


func _set_phase(value: String) -> void:
	if phase == value:
		return
	phase = value
	_clock = 0.0
	phase_changed.emit(phase)


func _has_foot_contact() -> bool:
	for collider in body.get_colliding_bodies():
		if collider in _feet:
			return true
	return false


func _physics_process(delta: float) -> void:
	if _reset_pending:
		_apply_reset()
		return
	if not is_instance_valid(body) or phase == "lost":
		return
	if body.position.y < 0.75 or Vector2(body.position.x, body.position.z).length() > 1.6:
		_launch_pending = false
		_set_phase("lost")
		missed.emit()
		return
	_clock += delta
	var contact := _has_foot_contact()
	if _launch_pending:
		_launch_pending = false
		if contact and body.linear_velocity.length() < 0.6:
			_rest_height = (_feet[0].position.y + _feet[1].position.y) * 0.5
			_flight_started = false
			_real_contact = false
			_set_phase("preparing")

	# Assistance changes the reachable shoe targets, never the table in midair.
	if _assistance and phase in ["supported", "receiving"]:
		var target := Vector2(body.position.x, body.position.z).limit_length(0.20)
		_lateral_target = _lateral_target.move_toward(target, 0.35 * delta)

	var target_height := REST_Y
	match phase:
		"preparing":
			if _clock < PREP_TIME:
				target_height = _rest_height - PREP_DEPTH * (0.5 - 0.5 * cos(PI * _clock / PREP_TIME))
			else:
				var time := minf(_clock - PREP_TIME, PUSH_TIME)
				target_height = _rest_height - PREP_DEPTH + 0.5 * PUSH_ACCELERATION * time * time
				if _clock >= PREP_TIME + PUSH_TIME:
					_set_phase("airborne")
		"airborne":
			# Retract after release, then return toward the receiving position.
			if _clock < 0.15:
				target_height = REST_Y - 0.15
			else:
				target_height = REST_Y + (0.05 if _assistance else 0.0)
			if not contact and body.position.y > REST_Y + 0.24:
				_flight_started = true
			var foot_top := maxf(_feet[0].position.y, _feet[1].position.y) + SHOE_SIZE.y * 0.5
			var near_feet := body.position.y - 0.05 < foot_top + 0.14
			if _flight_started and _clock > 0.2 and body.linear_velocity.y < -0.25 and near_feet:
				_catch_start_y = (_feet[0].position.y + _feet[1].position.y) * 0.5
				_catch_speed = clampf(-body.linear_velocity.y * 0.70, 0.6, 2.3) if _assistance else 0.0
				_stable_time = 0.0
				_set_phase("receiving")
		"receiving":
			_real_contact = _real_contact or contact
			var compression := _catch_speed * COMPRESSION_TIME * 0.5
			if _clock <= COMPRESSION_TIME:
				target_height = _catch_start_y - _catch_speed * _clock + 0.5 * _catch_speed / COMPRESSION_TIME * _clock * _clock
			else:
				var progress := clampf((_clock - COMPRESSION_TIME) / RECOVERY_TIME, 0.0, 1.0)
				target_height = lerpf(_catch_start_y - compression, REST_Y, 0.5 - 0.5 * cos(PI * progress))
			if contact and body.linear_velocity.length() < 0.45 and body.angular_velocity.length() < 0.9:
				_stable_time += delta
			else:
				_stable_time = 0.0
			if _clock > COMPRESSION_TIME + RECOVERY_TIME and _stable_time > 0.12:
				if _flight_started and _real_contact:
					returns += 1
					return_completed.emit(returns)
				_flight_started = false
				_set_phase("supported")

	for index in range(2):
		var height := target_height
		# Small physical asymmetry, applied only during the contacting push.
		if phase == "preparing" and _clock > PREP_TIME:
			var direction := -1.0 if index == 0 else 1.0
			height += direction * _side * 0.022 * clampf((_clock - PREP_TIME) / PUSH_TIME, 0.0, 1.0)
		var target := Vector3((-0.28 if index == 0 else 0.28) + _lateral_target.x, height, 0.10 + _lateral_target.y)
		_move_foot(index, target, delta)


func _move_foot(index: int, target: Vector3, delta: float) -> void:
	var offset := target - _feet[index].position
	var desired := (offset / delta).limit_length(MAX_FOOT_SPEED)
	var velocity := _foot_velocities[index].move_toward(desired, MAX_FOOT_ACCELERATION * delta)
	var step := velocity * delta
	if step.length_squared() > offset.length_squared() and step.dot(offset) > 0.0:
		step = offset
		velocity = step / delta
	_feet[index].position += step
	_foot_velocities[index] = velocity
	feet_positions[index] = _feet[index].global_position
