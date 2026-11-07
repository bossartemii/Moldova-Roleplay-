extends Control

var player: CharacterBody3D
var center := Vector2.ZERO
var radius := 68.0
var stick := Vector2.ZERO
var stick_id := -1
var look_id := -1
var run_id := -1
var run_rect := Rect2()
var jump_rect := Rect2()
var use_rect := Rect2()
var interaction_prompt := ""
var last_message := ""
var button_size := 72.0

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_STOP
    player = get_tree().current_scene.get_node_or_null("LocalPlayer")
    _layout()
    queue_redraw()

func _notification(what: int) -> void:
    if what == NOTIFICATION_RESIZED:
        _layout()
        queue_redraw()

func _process(_delta: float) -> void:
    if is_instance_valid(player):
        player.set_mobile_move(stick)
        var next_prompt: String = player.get_interaction_prompt()
        var next_message := player.last_interaction_message
        if next_prompt != interaction_prompt or next_message != last_message:
            interaction_prompt = next_prompt
            last_message = next_message
            queue_redraw()

func _layout() -> void:
    var size := get_viewport_rect().size
    radius = clampf(minf(size.x * 0.075, size.y * 0.12), 54.0, 76.0)
    button_size = clampf(minf(size.x * 0.17, size.y * 0.13), 58.0, 82.0)
    center = Vector2(maxf(radius + 22.0, size.x * 0.14), size.y - radius - 34.0)
    var right := size.x - 18.0
    var bottom := size.y - 22.0
    jump_rect = Rect2(right - button_size, bottom - button_size, button_size, button_size)
    run_rect = Rect2(right - button_size * 2.0 - 12.0, bottom - button_size, button_size, button_size)
    use_rect = Rect2(right - button_size, bottom - button_size * 2.0 - 32.0, button_size, button_size)

func _draw() -> void:
    draw_circle(center, radius, Color(0.04, 0.07, 0.1, 0.38))
    draw_arc(center, radius, 0.0, TAU, 48, Color(0.9, 0.93, 0.96, 0.6), 2.0)
    draw_circle(center + stick * radius * 0.62, radius * 0.36, Color(0.82, 0.88, 0.94, 0.68))
    _button(run_rect, "CORRI")
    _button(jump_rect, "SALTA")
    if not interaction_prompt.is_empty():
        _button(use_rect, "USA")
        var prompt_rect := Rect2(get_viewport_rect().size.x * 0.28, 58.0, get_viewport_rect().size.x * 0.48, 52.0)
        draw_rect(prompt_rect, Color(0.03, 0.05, 0.08, 0.78), true)
        draw_string(ThemeDB.fallback_font, prompt_rect.position + Vector2(12.0, 32.0), interaction_prompt, HORIZONTAL_ALIGNMENT_CENTER, prompt_rect.size.x - 24.0, 17, Color.WHITE)
    draw_string(ThemeDB.fallback_font, Vector2(18.0, 28.0), "MOLDOVA ROLEPLAY  |  CHIȘINĂU", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 16, Color.WHITE)
    if not last_message.is_empty():
        draw_string(ThemeDB.fallback_font, Vector2(18.0, 54.0), last_message, HORIZONTAL_ALIGNMENT_LEFT, get_viewport_rect().size.x * 0.62, 14, Color("ffe3a3"))

func _button(rect: Rect2, label: String) -> void:
    draw_rect(rect, Color(0.04, 0.07, 0.1, 0.48), true)
    draw_rect(rect, Color(0.9, 0.93, 0.96, 0.7), false, 2.0, true)
    var font_size := 15
    var text_width := ThemeDB.fallback_font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
    draw_string(ThemeDB.fallback_font, rect.position + Vector2((rect.size.x - text_width) * 0.5, rect.size.y * 0.58), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size, Color.WHITE)

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.distance_to(center) <= radius * 1.5:
                stick_id = event.index
                _move_stick(event.position)
            elif not interaction_prompt.is_empty() and use_rect.has_point(event.position):
                if is_instance_valid(player):
                    player.try_interact()
            elif run_rect.has_point(event.position):
                run_id = event.index
                if is_instance_valid(player):
                    player.set_mobile_sprint(true)
            elif jump_rect.has_point(event.position):
                if is_instance_valid(player):
                    player.request_jump()
            else:
                look_id = event.index
        else:
            if event.index == stick_id:
                stick_id = -1
                stick = Vector2.ZERO
            if event.index == look_id:
                look_id = -1
            if event.index == run_id:
                run_id = -1
                if is_instance_valid(player):
                    player.set_mobile_sprint(false)
            queue_redraw()
    elif event is InputEventScreenDrag:
        if event.index == stick_id:
            _move_stick(event.position)
        elif event.index == look_id and is_instance_valid(player):
            player.rotate_camera(event.relative)
        queue_redraw()

func _move_stick(position: Vector2) -> void:
    stick = ((position - center) / radius).limit_length(1.0)
    queue_redraw()
