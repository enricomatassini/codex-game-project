extends SceneTree
## End-to-end checks through the actual scene, touch controls and pause overlay.

var game: Node3D
var checks := 0
var failures := 0


func _initialize() -> void:
	root.size = Vector2i(540, 960)
	call_deferred("_run")


func _ticks(count: int) -> void:
	for index in range(count):
		await physics_frame


func _check(condition: bool, label: String) -> void:
	checks += 1
	print("PASS " if condition else "FAIL ", label)
	if not condition:
		failures += 1


func _tap(button_name: String) -> void:
	var button: Button = game.ui.find_child(button_name, true, false)
	assert(button != null, button_name)
	var event := InputEventScreenTouch.new()
	event.index = 0
	event.position = button.get_global_rect().get_center()
	event.pressed = true
	root.push_input(event, true)
	event = InputEventScreenTouch.new()
	event.index = 0
	event.position = button.get_global_rect().get_center()
	event.pressed = false
	root.push_input(event, true)


func _wait_for_return() -> void:
	for index in range(240):
		await _ticks(1)
		if game.rig.returns == 1 or game.rig.phase == "lost":
			return


func _run() -> void:
	game = load("res://scenes/main.tscn").instantiate()
	root.add_child(game)
	await _ticks(90)
	_check(game.rig.phase == "supported", "actual scene starts in stable support")
	_tap("BalancedKick")
	await _ticks(3)
	_check(game.rig.phase == "preparing", "native touch starts a balanced launch")
	await _wait_for_return()
	_check(game.rig.returns == 1, "touch launch completes an actual physical return")
	_check(game.ui._score.text == "01", "HUD displays the completed return")
	_check(game.best >= 1, "best score is updated")
	var progress := ConfigFile.new()
	_check(progress.load("user://progress.cfg") == OK and int(progress.get_value("game", "best", 0)) == game.best, "best score is persisted in the test profile")
	_tap("Pause")
	await _ticks(3)
	_check(paused and game.ui._overlay.visible, "pause button opens modal and pauses scene")
	var frozen_position: Vector3 = game.rig.body.position
	await _ticks(12)
	_check(game.rig.body.position.distance_to(frozen_position) < 0.00001, "physics does not advance while paused")
	_tap("ModalAction")
	await _ticks(3)
	_check(not paused and not game.ui._overlay.visible, "native touch resumes from the paused overlay")
	game.restart()
	await _ticks(90)
	_check(game.rig.returns == 0 and game.ui._score.text == "00", "restart clears score even while already supported")
	_check(game.best >= 1, "restart preserves best score")
	game.rig.body.position = Vector3(1.4, 0.6, 0.0)
	await _ticks(3)
	_check(game.rig.phase == "lost" and game.ui._overlay.visible, "real missed support opens the retry dialog")
	_tap("ModalAction")
	await _ticks(90)
	_check(game.rig.phase == "supported" and not game.ui._overlay.visible and game.rig.returns == 0, "retry touch restores a fresh playable scene")
	var key := InputEventKey.new()
	key.keycode = KEY_SPACE
	key.pressed = true
	root.push_input(key, true)
	await _ticks(3)
	_check(game.rig.phase == "preparing", "Space keyboard control reaches the same launch path")
	root.size = Vector2i(360, 780)
	await _ticks(3)
	var width: float = root.get_visible_rect().size.x
	_check(game.ui._left.get_global_rect().position.x >= 0.0 and game.ui._right.get_global_rect().end.x <= width, "touch controls stay within a narrow portrait viewport")
	print("GAME CHECKS: ", checks - failures, "/", checks, " passed; failures=", failures)
	game.queue_free()
	await _ticks(3)
	quit(1 if failures else 0)
