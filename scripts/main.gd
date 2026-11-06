extends Node3D

const RigScript = preload("res://scripts/table_rig.gd")
const VisualsScript = preload("res://scripts/world_visuals.gd")
const UIScript = preload("res://scripts/game_ui.gd")

var rig: Node3D
var visuals: Node3D
var ui: CanvasLayer
var best := 0
var elapsed := 0.0
var demo := false
var capture_path := ""
var capture_started := false
var next_demo_launch := 1.0
var initialized := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for arg in OS.get_cmdline_user_args():
		if arg == "--demo":
			demo = true
		if arg.begins_with("--capture="):
			capture_path = arg.trim_prefix("--capture=")
	var saved := ConfigFile.new()
	if saved.load("user://progress.cfg") == OK:
		best = maxi(0, int(saved.get_value("game", "best", 0)))
	rig = RigScript.new()
	rig.name = "TableRig"
	rig.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(rig)
	visuals = VisualsScript.new()
	visuals.name = "WorldVisuals"
	visuals.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(visuals)
	visuals.build(rig.body)
	visuals.update_feet(rig.feet_positions, 0.0)
	var camera := Camera3D.new()
	camera.name = "Camera"
	camera.position = Vector3(0.0, 0.15, 1.0)
	camera.fov = 72.0
	camera.near = 0.05
	camera.far = 100.0
	add_child(camera)
	camera.look_at(Vector3(0.0, 2.8, 0.0), Vector3(0.0, 0.0, -1.0))
	camera.current = true
	ui = UIScript.new()
	ui.name = "GameUI"
	add_child(ui)
	ui.kick_requested.connect(_kick)
	ui.restart_requested.connect(restart)
	ui.pause_requested.connect(toggle_pause)
	rig.phase_changed.connect(_phase_changed)
	rig.return_completed.connect(_returned)
	ui.set_best(best)
	ui.set_status(rig.phase, rig.returns)
	initialized = true


func _process(delta: float) -> void:
	if not initialized:
		return
	if not get_tree().paused:
		elapsed += delta
		visuals.update_feet(rig.feet_positions, delta)
		if demo and elapsed >= next_demo_launch:
			if rig.phase == "supported":
				_kick(0)
				next_demo_launch = elapsed + 2.6
			elif rig.phase == "lost":
				restart()
	if not capture_path.is_empty() and not capture_started and elapsed > 1.8:
		capture_started = true
		_capture()


func _capture() -> void:
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	if image != null and not image.is_empty():
		var result := image.save_png(capture_path)
		if result != OK:
			push_error("Screenshot save failed: %s" % result)
	get_tree().quit()


func _kick(side: int) -> void:
	if initialized and not get_tree().paused:
		rig.launch(side)


func _phase_changed(phase: String) -> void:
	if is_instance_valid(ui):
		ui.set_status(phase, rig.returns)


func _returned(total: int) -> void:
	if total > best:
		best = total
		var saved := ConfigFile.new()
		saved.set_value("game", "best", best)
		var result := saved.save("user://progress.cfg")
		if result != OK:
			push_warning("Best score could not be saved.")
	ui.set_best(best)
	ui.set_status(rig.phase, total)


func restart() -> void:
	get_tree().paused = false
	ui.set_paused(false)
	rig.reset()
	ui.set_status("supported", 0)


func toggle_pause() -> void:
	get_tree().paused = not get_tree().paused
	ui.set_paused(get_tree().paused)


func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.keycode:
		KEY_SPACE:
			_kick(0)
		KEY_A, KEY_LEFT:
			_kick(-1)
		KEY_D, KEY_RIGHT:
			_kick(1)
		KEY_R:
			restart()
		KEY_ESCAPE:
			toggle_pause()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_PAUSED and initialized:
		get_tree().paused = true
		ui.set_paused(true)
