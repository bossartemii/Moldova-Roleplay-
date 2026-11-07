extends Control

var player: CharacterBody3D
var center:=Vector2.ZERO
var radius:=76.0
var stick:=Vector2.ZERO
var stick_id:=-1
var look_id:=-1
var last_look:=Vector2.ZERO
var run_rect:=Rect2()
var jump_rect:=Rect2()

func _ready() -> void:
    player=get_tree().current_scene.get_node_or_null("LocalPlayer")
    queue_redraw()

func _process(_delta: float) -> void:
    if player: player.set_mobile_move(stick)

func _draw() -> void:
    var size=get_viewport_rect().size
    center=Vector2(112,size.y-128)
    run_rect=Rect2(size.x-210,size.y-150,82,82)
    jump_rect=Rect2(size.x-108,size.y-150,82,82)
    draw_circle(center,radius,Color(0.04,0.07,0.1,0.38))
    draw_arc(center,radius,0,TAU,48,Color(0.9,0.93,0.96,0.6),2)
    draw_circle(center+stick*48,28,Color(0.82,0.88,0.94,0.65))
    _button(run_rect,"RUN")
    _button(jump_rect,"JUMP")
    draw_string(ThemeDB.fallback_font,Vector2(22,34),"MOLDOVA ROLEPLAY  |  CHIȘINĂU  |  PROTOTYPE",HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color.WHITE)

func _button(r: Rect2,t: String) -> void:
    draw_rect(r,Color(0.04,0.07,0.1,0.42),true,12)
    draw_rect(r,Color(0.9,0.93,0.96,0.65),false,12,2)
    draw_string(ThemeDB.fallback_font,r.position+Vector2(17,48),t,HORIZONTAL_ALIGNMENT_LEFT,-1,18,Color.WHITE)

func _gui_input(e: InputEvent) -> void:
    if e is InputEventScreenTouch:
        if e.pressed:
            if e.position.distance_to(center)<=radius*1.5:
                stick_id=e.index
                _move_stick(e.position)
            elif run_rect.has_point(e.position):
                if player: player.set_mobile_sprint(true)
            elif jump_rect.has_point(e.position):
                if player: player.request_jump()
            else:
                look_id=e.index
        else:
            if e.index==stick_id: stick_id=-1; stick=Vector2.ZERO
            if e.index==look_id: look_id=-1
            if run_rect.has_point(e.position) and player: player.set_mobile_sprint(false)
            queue_redraw()
    elif e is InputEventScreenDrag:
        if e.index==stick_id: _move_stick(e.position)
        elif e.index==look_id and player: player.rotate_camera(e.relative)
        queue_redraw()

func _move_stick(p: Vector2) -> void:
    stick=((p-center)/radius).limit_length(1.0)
    queue_redraw()
