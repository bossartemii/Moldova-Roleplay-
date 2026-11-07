extends Control

var player: CharacterBody3D

# Configurazione Joystick (Metà Sinistra)
var default_center := Vector2.ZERO
var center := Vector2.ZERO
var radius := 68.0
var stick_visual := Vector2.ZERO
var stick_vector := Vector2.ZERO

# Tracking Indici Touch
var stick_id := -1
var look_id := -1
var run_id := -1

# Hitbox Pulsanti (Metà Destra)
var run_rect := Rect2()
var jump_rect := Rect2()
var use_rect := Rect2()
var button_size := 72.0

var interaction_prompt := ""
var last_message := ""

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_find_player()
	_layout()
	queue_redraw()

func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		_layout()
		queue_redraw()

func _process(_delta: float) -> void:
	if not is_instance_valid(player):
		_find_player()
		return

	# Invia il vettore al player invertendo Y (nello schermo UP è negativo, per il player UP è positivo)
	player.set_mobile_move(stick_vector)

	var next_prompt := player.get_interaction_prompt()
	var next_message := player.last_interaction_message
	if next_prompt != interaction_prompt or next_message != last_message:
		interaction_prompt = next_prompt
		last_message = next_message
		queue_redraw()

func _find_player() -> void:
	# Cerca LocalPlayer nella scena corrente, oppure il primo CharacterBody3D disponibile
	player = get_tree().current_scene.get_node_or_null("LocalPlayer")
	if player == null:
		player = get_tree().current_scene.find_child("LocalPlayer", true, false) as CharacterBody3D

func _layout() -> void:
	var screen_size := get_viewport_rect().size
	radius = clampf(minf(screen_size.x * 0.08, screen_size.y * 0.13), 56.0, 80.0)
	button_size = clampf(minf(screen_size.x * 0.16, screen_size.y * 0.14), 62.0, 84.0)

	default_center = Vector2(radius + 40.0, screen_size.y - radius - 44.0)
	center = default_center

	var right := screen_size.x - 20.0
	var bottom := screen_size.y - 24.0

	jump_rect = Rect2(right - button_size, bottom - button_size, button_size, button_size)
	run_rect = Rect2(right - button_size * 2.0 - 16.0, bottom - button_size, button_size, button_size)
	use_rect = Rect2(right - button_size, bottom - button_size * 2.0 - 36.0, button_size, button_size)

func _gui_input(event: InputEvent) -> void:
	var screen_width := get_viewport_rect().size.x
	var needs_redraw := false

	if event is InputEventScreenTouch:
		if event.pressed:
			# METÀ SINISTRA: Gestione Joystick
			if event.position.x < screen_width * 0.5:
				if stick_id == -1:
					stick_id = event.index
					# Riposiziona il centro sul punto di contatto per massima comodità (floating joystick)
					center = event.position
					_update_stick(event.position)
					needs_redraw = true
			# METÀ DESTRA: Pulsanti e Rotazione Camera
			else:
				if not interaction_prompt.is_empty() and use_rect.has_point(event.position):
					if is_instance_valid(player):
						player.try_interact()
				elif run_rect.has_point(event.position):
					run_id = event.index
					if is_instance_valid(player):
						player.set_mobile_sprint(true)
					needs_redraw = true
				elif jump_rect.has_point(event.position):
					if is_instance_valid(player):
						player.request_jump()
				elif look_id == -1:
					look_id = event.index
		else:
			# Rilascio Touch
			if event.index == stick_id:
				stick_id = -1
				stick_visual = Vector2.ZERO
				stick_vector = Vector2.ZERO
				center = default_center
				needs_redraw = true

			if event.index == run_id:
				run_id = -1
				if is_instance_valid(player):
					player.set_mobile_sprint(false)
				needs_redraw = true

			if event.index == look_id:
				look_id = -1

	elif event is InputEventScreenDrag:
		if event.index == stick_id:
			_update_stick(event.position)
			needs_redraw = true
		elif event.index == look_id and is_instance_valid(player):
			player.rotate_camera(event.relative)

	if needs_redraw:
		queue_redraw()

func _update_stick(touch_position: Vector2) -> void:
	var diff := touch_position - center
	var dist := diff.length()
	var dir := diff.normalized() if dist > 0.0 else Vector2.ZERO

	var clamped_dist := minf(dist, radius)
	stick_visual = (dir * clamped_dist) / radius
	# stick_vector: X = Destra/Sinistra, Y = invertito per allineare l'avanzamento 3D
	stick_vector = Vector2(stick_visual.x, -stick_visual.y)

func _draw() -> void:
	var screen_size := get_viewport_rect().size

	# 1. Joystick
	draw_circle(center, radius, Color(0.04, 0.07, 0.1, 0.38))
	draw_arc(center, radius, 0.0, TAU, 48, Color(0.9, 0.93, 0.96, 0.6), 2.0)
	draw_circle(center + stick_visual * radius * 0.65, radius * 0.36, Color(0.82, 0.88, 0.94, 0.75))

	# 2. Pulsanti
	var run_active := (run_id != -1)
	_draw_button(run_rect, "CORRI", run_active)
	_draw_button(jump_rect, "SALTA", false)

	if not interaction_prompt.is_empty():
		_draw_button(use_rect, "USA", false)
		var prompt_rect := Rect2(screen_size.x * 0.25, 48.0, screen_size.x * 0.5, 48.0)
		draw_rect(prompt_rect, Color(0.03, 0.05, 0.08, 0.8), true)
		draw_rect(prompt_rect, Color(0.9, 0.93, 0.96, 0.4), false, 1.5)
		draw_string(ThemeDB.fallback_font, prompt_rect.position + Vector2(0.0, 30.0), interaction_prompt, HORIZONTAL_ALIGNMENT_CENTER, prompt_rect.size.x, 16, Color.WHITE)

	# 3. Watermark e Notifiche
	draw_string(ThemeDB.fallback_font, Vector2(24.0, 36.0), "MOLDOVA ROLEPLAY", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, Color(1.0, 1.0, 1.0, 0.85))
	if not last_message.is_empty():
		draw_string(ThemeDB.fallback_font, Vector2(24.0, 62.0), last_message, HORIZONTAL_ALIGNMENT_LEFT, screen_size.x * 0.6, 14, Color("ffe3a3"))

func _draw_button(rect: Rect2, label: String, is_pressed: bool) -> void:
	var bg_color := Color(0.18, 0.28, 0.42, 0.75) if is_pressed else Color(0.04, 0.07, 0.1, 0.48)
	var border_color := Color(1.0, 1.0, 1.0, 0.9) if is_pressed else Color(0.9, 0.93, 0.96, 0.6)

	draw_rect(rect, bg_color, true)
	draw_rect(rect, border_color, false, 2.0)

	var font_size := 15
	var text_y := rect.position.y + (rect.size.y * 0.58)
	draw_string(ThemeDB.fallback_font, Vector2(rect.position.x, text_y), label, HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, Color.WHITE)
