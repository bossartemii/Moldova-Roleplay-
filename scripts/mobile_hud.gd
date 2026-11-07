extends Control

var player: CharacterBody3D
var center := Vector2.ZERO
var radius := 76.0
var stick := Vector2.ZERO
var stick_id := -1
var look_id := -1
var run_id := -1
var run_rect := Rect2()
var jump_rect := Rect2()

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

func _layout() -> void:
    var size := get_viewport_rect().size
    center = Vector2(112.0, size.y - 128.0)
    run_rect = Rect2(size.x - 210.0, size.y - 150.0, 82.0, 82.0)
    jump_rect = Rect2(size.x - 108.0, size.y - 150.0, 82.0, 82.0)

func _draw() -> void:
    draw_circle(center, radius, Color(0.04, 0.07, 0.1, 0.38))
    draw_arc(center, radius, 0.0, TAU, 48, Color(0.9, 0.93, 0.96, 0.6), 2.0)
    draw_circle(center + stick * 48.0, 28.0, Color(0.82, 0.88, 0.94, 0.65))
    _button(run_rect, "RUN")
    _button(jump_rect, "JUMP")
    draw_string(ThemeDB.fallback_font, Vector2(22.0, 34.0), "MOLDOVA ROLEPLAY  |  CHIȘINĂU  |  PROTOTYPE", HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color.WHITE)

func _button(rect: Rect2, label: String) -> void:
    draw_rect(rect, Color(0.04, 0.07, 0.1, 0.42), true)
    draw_rect(rect, Color(0.9, 0.93, 0.96, 0.65), false, 2.0, true)
    draw_string(ThemeDB.fallback_font, rect.position + Vector2(17.0, 48.0), label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, 18, Color.WHITE)

func _gui_input(event: InputEvent) -> void:
    if event is InputEventScreenTouch:
        if event.pressed:
            if event.position.distance_to(center) <= radius * 1.5:
                stick_id = event.index
                _move_stick(event.position)
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
