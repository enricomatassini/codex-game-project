extends CanvasLayer
## Portrait HUD. All physics and keyboard input belong to the game controller.

signal kick_requested(side: int)
signal restart_requested
signal pause_requested

const INK := Color("172d3c")
const CREAM := Color("fff7e5")
const GOLD := Color("f3bf62")
const MUTED := Color("9eb4bc")

var _root: Control
var _header: PanelContainer
var _brand_title: Label
var _tray: PanelContainer
var _score: Label
var _best_label: Label
var _feedback: Label
var _hint: Label
var _launch: Button
var _left: Button
var _right: Button
var _pause: Button
var _overlay: ColorRect
var _dialog: PanelContainer
var _dialog_title: Label
var _dialog_score: Label
var _dialog_body: Label
var _dialog_action: Button
var _phase := "supported"
var _returns := 0
var _best := 0
var _paused := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 10
	_root = Control.new()
	_root.name = "HUD"
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_build_header()
	_build_controls()
	_build_overlay()
	get_viewport().size_changed.connect(_layout)
	_layout()
	_refresh()


func set_status(phase: String, returns: int) -> void:
	_phase = phase
	_returns = returns
	if is_instance_valid(_score):
		_refresh()


func set_paused(value: bool) -> void:
	_paused = value
	if is_instance_valid(_overlay):
		_refresh()


func set_best(value: int) -> void:
	_best = maxi(value, 0)
	if is_instance_valid(_best_label):
		_best_label.text = "RECORD  %02d" % _best


func _input(event: InputEvent) -> void:
	# The project disables mouse emulation from touch, so handle native taps too.
	if not event is InputEventScreenTouch or not event.pressed:
		return
	var buttons: Array[Button] = []
	if _overlay.visible:
		buttons.append(_dialog_action)
	else:
		buttons.assign([_left, _launch, _right, _pause])
	for button in buttons:
		if button.is_visible_in_tree() and not button.disabled and button.get_global_rect().has_point(event.position):
			button.pressed.emit()
			get_viewport().set_input_as_handled()
			return
	if _overlay.visible:
		get_viewport().set_input_as_handled()


func _build_header() -> void:
	_header = PanelContainer.new()
	_header.name = "Header"
	_header.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_header.add_theme_stylebox_override("panel", _panel(Color(0.98, 0.96, 0.90, 0.94), 22, 16))
	_root.add_child(_header)
	var row := HBoxContainer.new()
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	row.add_theme_constant_override("separation", 14)
	_header.add_child(row)
	var brand := VBoxContainer.new()
	brand.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	brand.alignment = BoxContainer.ALIGNMENT_CENTER
	brand.add_theme_constant_override("separation", 3)
	row.add_child(brand)
	_brand_title = _label("S O S P E S O", 23, INK)
	brand.add_child(_brand_title)
	_best_label = _label("RECORD  00", 11, Color("52707b"))
	brand.add_child(_best_label)
	var tally := VBoxContainer.new()
	tally.alignment = BoxContainer.ALIGNMENT_CENTER
	tally.add_theme_constant_override("separation", 0)
	row.add_child(tally)
	_score = _label("00", 32, INK)
	_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tally.add_child(_score)
	var score_caption := _label("RILANCI", 10, Color("52707b"))
	score_caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tally.add_child(score_caption)
	_pause = _button("II", false)
	_pause.name = "Pause"
	_pause.custom_minimum_size = Vector2(44, 48)
	_pause.add_theme_color_override("font_color", INK)
	_pause.add_theme_color_override("font_hover_color", INK)
	_pause.add_theme_color_override("font_pressed_color", INK)
	_pause.add_theme_stylebox_override("normal", _panel(Color(0.09, 0.18, 0.23, 0.07), 14, 6))
	_pause.add_theme_stylebox_override("hover", _panel(Color(0.09, 0.18, 0.23, 0.14), 14, 6))
	_pause.pressed.connect(func() -> void: pause_requested.emit())
	row.add_child(_pause)


func _build_controls() -> void:
	_tray = PanelContainer.new()
	_tray.name = "Controls"
	_tray.add_theme_stylebox_override("panel", _panel(Color(0.06, 0.13, 0.18, 0.94), 25, 18))
	_root.add_child(_tray)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	_tray.add_child(column)
	_feedback = _label("TROVA IL RITMO", 12, GOLD)
	_feedback.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_feedback)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	column.add_child(row)
	_left = _button("SINISTRO", false)
	_left.name = "LeftKick"
	_left.custom_minimum_size = Vector2(94, 64)
	_left.add_theme_font_size_override("font_size", 12)
	_left.pressed.connect(_request_kick.bind(-1))
	row.add_child(_left)
	_launch = _button("LANCIA", true)
	_launch.name = "BalancedKick"
	_launch.custom_minimum_size = Vector2(80, 64)
	_launch.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_launch.pressed.connect(_request_kick.bind(0))
	row.add_child(_launch)
	_right = _button("DESTRO", false)
	_right.name = "RightKick"
	_right.custom_minimum_size = Vector2(94, 64)
	_right.add_theme_font_size_override("font_size", 12)
	_right.pressed.connect(_request_kick.bind(1))
	row.add_child(_right)
	_hint = _label("Tocca LANCIA. Trova il ritmo.", 13, MUTED)
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_hint)


func _build_overlay() -> void:
	_overlay = ColorRect.new()
	_overlay.name = "ModalOverlay"
	_overlay.color = Color(0.035, 0.07, 0.10, 0.76)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(_overlay)
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	_overlay.add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_dialog = PanelContainer.new()
	_dialog.custom_minimum_size = Vector2(400, 0)
	_dialog.add_theme_stylebox_override("panel", _panel(CREAM, 28, 30))
	center.add_child(_dialog)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 18)
	_dialog.add_child(column)
	var eyebrow := _label("S O S P E S O", 13, Color("7b6140"))
	eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(eyebrow)
	_dialog_title = _label("UN ALTRO GIRO?", 27, INK)
	_dialog_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_dialog_title)
	_dialog_score = _label("0", 76, INK)
	_dialog_score.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_dialog_score)
	_dialog_body = _label("rilanci riusciti", 16, Color("52707b"))
	_dialog_body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_dialog_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_dialog_body)
	_dialog_action = _button("RIPROVA", true)
	_dialog_action.name = "ModalAction"
	_dialog_action.custom_minimum_size = Vector2(0, 64)
	_dialog_action.pressed.connect(_activate_dialog)
	column.add_child(_dialog_action)


func _refresh() -> void:
	_score.text = "%02d" % _returns
	_best_label.text = "RECORD  %02d" % maxi(_best, _returns)
	var can_launch := _phase == "supported" and not _paused
	_launch.disabled = not can_launch
	_left.disabled = not can_launch
	_right.disabled = not can_launch
	_pause.disabled = _phase == "lost"
	match _phase:
		"preparing":
			_feedback.text = "PREPARA LA SPINTA"
			_hint.text = "Un gesto, poi lascia volare."
		"airborne":
			_feedback.text = "IN VOLO"
			_hint.text = "Segui il tavolo."
		"receiving":
			_feedback.text = "ACCOMPAGNA"
			_hint.text = "Ritrova l'appoggio."
		"lost":
			_feedback.text = "SI RIPARTE"
			_hint.text = "Il prossimo lancio è quello giusto."
		_:
			_feedback.text = "TROVA IL RITMO" if _returns == 0 else "APPOGGIO RITROVATO"
			_hint.text = "Tocca LANCIA. Trova il ritmo." if _returns == 0 else "Un altro lancio, un nuovo equilibrio."
	_overlay.visible = _paused or _phase == "lost"
	if _paused:
		_dialog_title.text = "PRENDI FIATO"
		_dialog_score.visible = false
		_dialog_body.text = "Il tavolo ti aspetta."
		_dialog_action.text = "RIPRENDI"
	else:
		_dialog_title.text = "UN ALTRO GIRO?"
		_dialog_score.visible = true
		_dialog_score.text = str(_returns)
		_dialog_body.text = "rilancio riuscito" if _returns == 1 else "rilanci riusciti"
		_dialog_action.text = "RIPROVA"


func _request_kick(side: int) -> void:
	if _phase == "supported" and not _paused:
		kick_requested.emit(side)


func _activate_dialog() -> void:
	if _paused:
		pause_requested.emit()
	elif _phase == "lost":
		restart_requested.emit()


func _layout() -> void:
	var view_size := get_viewport().get_visible_rect().size
	var inset := Vector4.ZERO
	if OS.has_feature("android") or OS.has_feature("ios"):
		var safe := DisplayServer.get_display_safe_area()
		var screen := DisplayServer.screen_get_size()
		if safe.size.x > 0 and safe.size.y > 0 and screen.x > 0 and screen.y > 0:
			inset.x = float(safe.position.x) / screen.x * view_size.x
			inset.y = float(safe.position.y) / screen.y * view_size.y
			inset.z = float(screen.x - safe.end.x) / screen.x * view_size.x
			inset.w = float(screen.y - safe.end.y) / screen.y * view_size.y
	_header.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	_header.offset_left = 24 + inset.x
	_header.offset_top = 22 + inset.y
	_header.offset_right = -24 - inset.z
	_header.offset_bottom = 112 + inset.y
	_tray.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_tray.offset_left = 24 + inset.x
	_tray.offset_right = -24 - inset.z
	_tray.offset_top = -190 - inset.w
	_tray.offset_bottom = -24 - inset.w
	_dialog.custom_minimum_size.x = minf(400.0, view_size.x - 48.0 - inset.x - inset.z)
	var narrow := view_size.x - inset.x - inset.z < 430.0
	_brand_title.add_theme_font_size_override("font_size", 18 if narrow else 23)
	_left.custom_minimum_size.x = 64.0 if narrow else 94.0
	_right.custom_minimum_size.x = 64.0 if narrow else 94.0
	_left.text = "SX" if narrow else "SINISTRO"
	_right.text = "DX" if narrow else "DESTRO"


func _label(text: String, size: int, color: Color) -> Label:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	return label


func _button(text: String, primary: bool) -> Button:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_NONE
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", INK if primary else CREAM)
	button.add_theme_color_override("font_hover_color", INK if primary else CREAM)
	button.add_theme_color_override("font_pressed_color", INK if primary else CREAM)
	button.add_theme_color_override("font_disabled_color", Color("778991"))
	button.add_theme_stylebox_override("normal", _panel(GOLD if primary else Color("294652"), 17, 10))
	button.add_theme_stylebox_override("hover", _panel(Color("ffd286") if primary else Color("395867"), 17, 10))
	button.add_theme_stylebox_override("pressed", _panel(Color("dea54d") if primary else Color("203b48"), 17, 10))
	button.add_theme_stylebox_override("disabled", _panel(Color("233943"), 17, 10))
	return button


func _panel(color: Color, radius: int, padding: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = padding
	style.content_margin_right = padding
	style.content_margin_top = padding
	style.content_margin_bottom = padding
	return style
