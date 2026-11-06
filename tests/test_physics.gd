extends SceneTree
## Headless numerical and gameplay smoke checks using the production rig.

const Rig := preload("res://scripts/table_rig.gd")
var failures := 0
var checks := 0
var rig: Node3D


func _initialize() -> void:
	call_deferred("_run")


func _ticks(count: int) -> void:
	for tick in range(count):
		await physics_frame


func _check(condition: bool, label: String) -> void:
	checks += 1
	if condition:
		print("PASS ", label)
	else:
		failures += 1
		push_error("FAIL " + label)


func _fresh() -> void:
	if is_instance_valid(rig):
		rig.queue_free()
		await _ticks(2)
	rig = Rig.new()
	root.add_child(rig)
	await _ticks(2)


func _run() -> void:
	await _fresh()
	_check(absf(float(ProjectSettings.get_setting("physics/3d/default_gravity")) - 9.81) < 0.001, "world gravity is 9.81 m/s²")
	rig.set_assistance(false)
	rig.body.collision_mask = 0
	rig.body.collision_layer = 0
	rig.body.position = Vector3(0.0, 6.0, 0.0)
	rig.body.linear_velocity = Vector3.ZERO
	rig.body.angular_velocity = Vector3.ZERO
	await _ticks(3)
	var start_y: float = rig.body.position.y
	var start_v: float = rig.body.linear_velocity.y
	await _ticks(24)
	var elapsed := 24.0 / float(Engine.physics_ticks_per_second)
	var expected_y := start_y + start_v * elapsed - 0.5 * 9.81 * elapsed * elapsed
	_check(absf(rig.body.linear_velocity.y - (start_v - 9.81 * elapsed)) < 0.05, "free flight accelerates under gravity")
	_check(absf(rig.body.position.y - expected_y) < 0.05, "free fall agrees with ballistic displacement")
	_check(rig.body.angular_velocity.length() < 0.001, "gravity does not create spin from rest")

	# Use the actual table inertia/collider assembly, away from every contact.
	rig.body.linear_velocity = Vector3.ZERO
	rig.body.angular_velocity = Vector3.ZERO
	rig.body.apply_central_impulse(Vector3.UP * Rig.TABLE_MASS)
	await _ticks(2)
	_check(rig.body.angular_velocity.length() < 0.001, "centered impulse creates no rotation")
	rig.body.angular_velocity = Vector3.ZERO
	rig.body.apply_impulse(Vector3.UP * Rig.TABLE_MASS, Vector3(0.4, 0.0, 0.0))
	await _ticks(2)
	_check(rig.body.angular_velocity.z > 0.05, "right off-center impulse creates positive Z angular motion")
	rig.body.angular_velocity = Vector3.ZERO
	rig.body.apply_impulse(Vector3.UP * Rig.TABLE_MASS, Vector3(-0.4, 0.0, 0.0))
	await _ticks(2)
	_check(rig.body.angular_velocity.z < -0.05, "left off-center impulse reverses angular motion")

	await _fresh()
	await _ticks(90)
	print("SUPPORT y=", rig.body.position.y, " v=", rig.body.linear_velocity, " angular=", rig.body.angular_velocity)
	_check(rig.phase == "supported" and absf(rig.body.position.y - 2.26) < 0.08 and rig.body.linear_velocity.length() < 0.12, "table settles on two physical soles")
	var maximum_height := 0.0
	var total_air_taps := 0
	for cycle in range(3):
		rig.launch(0)
		var saw_airborne := false
		var saw_receiving := false
		var previous_phase: String = rig.phase
		var air_v_before := 0.0
		var air_checks_done := false
		for tick in range(240):
			await _ticks(1)
			maximum_height = maxf(maximum_height, rig.body.position.y)
			if previous_phase != rig.phase:
				print("CYCLE ", cycle, " tick ", tick, " ", rig.phase, " y=", rig.body.position.y, " vy=", rig.body.linear_velocity.y)
				previous_phase = rig.phase
			if rig.phase == "airborne":
				saw_airborne = true
				if rig.body.position.y > 2.58 and rig.body.linear_velocity.y > 0.3 and not air_checks_done:
					air_v_before = rig.body.linear_velocity.y
					for attempt in range(5):
						rig.launch(-1)
						rig.launch(1)
						total_air_taps += 2
					await _ticks(2)
					_check(rig.body.linear_velocity.y <= air_v_before + 0.02, "air taps cannot add upward velocity, cycle " + str(cycle))
					air_checks_done = true
			if rig.phase == "receiving":
				saw_receiving = true
			if rig.phase == "supported" and rig.returns >= cycle + 1:
				break
			if rig.phase == "lost":
				break
		_check(saw_airborne and saw_receiving and rig.phase == "supported" and rig.returns == cycle + 1, "physical launch, reception and stable return " + str(cycle + 1))
		await _ticks(20)
	_check(maximum_height > 2.60 and maximum_height < 3.5, "launch height remains bounded across repeated contacts")
	_check(total_air_taps >= 10, "airborne input rejection was actually exercised")
	var count_before: int = rig.returns
	await _ticks(90)
	_check(rig.returns == count_before, "passive support never repeats the return count")
	for side in [-1, 1]:
		await _fresh()
		await _ticks(60)
		rig.launch(side)
		var signed_peak := 0.0
		for tick in range(210):
			await _ticks(1)
			if rig.phase == "airborne":
				var spin: float = rig.body.angular_velocity.z
				if absf(spin) > absf(signed_peak):
					signed_peak = spin
			if rig.returns == 1 or rig.phase == "lost":
				break
		print("SIDE ", side, " spin=", signed_peak, " phase=", rig.phase, " position=", rig.body.position)
		_check(signed_peak * side > 0.025, "asymmetric foot motion produces intended rotation " + str(side))
		_check(rig.returns == 1 and rig.phase == "supported", "moderate asymmetric gesture remains recoverable " + str(side))

	# Missing the soles is a real fall; no support force exists at a distance.
	rig.body.position = Vector3(1.2, 2.1, 0.0)
	rig.body.linear_velocity = Vector3(0.3, -0.5, 0.0)
	await _ticks(70)
	_check(rig.phase == "lost", "missed support produces a failure")
	rig.reset()
	await _ticks(90)
	_check(rig.phase == "supported" and rig.returns == 0 and rig.body.linear_velocity.length() < 0.12, "reset restores a stable dynamic body and clears score")
	print("PHYSICS CHECKS: ", checks - failures, "/", checks, " passed; failures=", failures)
	rig.queue_free()
	await _ticks(2)
	quit(1 if failures else 0)
