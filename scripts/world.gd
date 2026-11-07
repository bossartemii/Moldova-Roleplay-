extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player.gd")
const HUD_SCRIPT = preload("res://scripts/mobile_hud.gd")

func _ready() -> void:
    var env_node := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.72, 0.78, 0.86)
    env_node.environment = env
    add_child(env_node)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -28, 0)
    add_child(sun)
    _box("Ground", Vector3(0,-0.25,0), Vector3(260,0.5,260), Color("66745f"))
    _box("Stefan_cel_Mare_Boulevard", Vector3(0,0.03,0), Vector3(18,0.08,220), Color("30363b"))
    _box("Central_Street", Vector3(0,0.04,0), Vector3(220,0.08,18), Color("30363b"))
    var positions = [Vector3(-28,8,-27),Vector3(28,11,-27),Vector3(-28,9,28),Vector3(28,13,28),Vector3(-62,10,-28),Vector3(62,12,28),Vector3(-62,8,28),Vector3(62,9,-28)]
    var colors = [Color("c8b9a2"),Color("b7c0c5"),Color("d0c7b8"),Color("9ea9a5")]
    for i in positions.size():
        _box("Building_%02d" % i, positions[i], Vector3(18, positions[i].y*2, 19), colors[i%colors.size()])
    _box("Civic_Square", Vector3(0,0.16,-52), Vector3(52,0.25,34), Color("b9b3a8"))
    _box("Civic_Hall_Blockout", Vector3(0,8,-72), Vector3(25,16,12), Color("d4c8b4"))
    var player := CharacterBody3D.new()
    player.name = "LocalPlayer"
    player.set_script(PLAYER_SCRIPT)
    player.position = Vector3(0,1.2,22)
    add_child(player)
    var layer := CanvasLayer.new()
    var hud := Control.new()
    hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    hud.set_script(HUD_SCRIPT)
    layer.add_child(hud)
    add_child(layer)

func _box(n: String, p: Vector3, s: Vector3, c: Color) -> void:
    var body := StaticBody3D.new()
    body.name=n
    body.position=p
    var mi:=MeshInstance3D.new()
    var mesh:=BoxMesh.new()
    mesh.size=s
    mi.mesh=mesh
    var mat:=StandardMaterial3D.new()
    mat.albedo_color=c
    mi.material_override=mat
    body.add_child(mi)
    var cs:=CollisionShape3D.new()
    var shape:=BoxShape3D.new()
    shape.size=s
    cs.shape=shape
    body.add_child(cs)
    add_child(body)
