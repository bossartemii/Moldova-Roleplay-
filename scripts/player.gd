extends CharacterBody3D

const SPEED=5.2
const GRAVITY=18.0
var camera_pivot: Node3D
var camera: Camera3D
var mobile_move:=Vector2.ZERO
var sprinting:=false
var jumping:=false

func _ready() -> void:
    var visual:=MeshInstance3D.new()
    var capsule:=CapsuleMesh.new()
    capsule.radius=0.42
    capsule.height=1.8
    visual.mesh=capsule
    visual.position.y=0.9
    var mat:=StandardMaterial3D.new()
    mat.albedo_color=Color("283d55")
    visual.material_override=mat
    add_child(visual)
    var col:=CollisionShape3D.new()
    var shape:=CapsuleShape3D.new()
    shape.radius=0.42
    shape.height=1.8
    col.shape=shape
    col.position.y=0.9
    add_child(col)
    camera_pivot=Node3D.new()
    camera_pivot.position.y=1.55
    add_child(camera_pivot)
    camera=Camera3D.new()
    camera.position=Vector3(0,1,5.8)
    camera.rotation_degrees.x=-12
    camera.current=true
    camera_pivot.add_child(camera)

func _physics_process(delta: float) -> void:
    if not is_on_floor(): velocity.y-=GRAVITY*delta
    elif jumping: velocity.y=4.5; jumping=false
    var input:=Input.get_vector("ui_left","ui_right","ui_up","ui_down")
    if input.length()<0.05: input=mobile_move
    var dir:=(-global_transform.basis.z*input.y+global_transform.basis.x*input.x).normalized()
    var speed:=7.4 if sprinting else SPEED
    velocity.x=dir.x*speed
    velocity.z=dir.z*speed
    if dir.length()>0.05: rotation.y=lerp_angle(rotation.y,atan2(-dir.x,-dir.z),delta*9.0)
    move_and_slide()

func set_mobile_move(v: Vector2) -> void: mobile_move=v
func set_mobile_sprint(v: bool) -> void: sprinting=v
func request_jump() -> void:
    if is_on_floor(): jumping=true
func rotate_camera(d: Vector2) -> void:
    camera_pivot.rotate_y(-d.x*0.004)
    camera.rotation.x=clamp(camera.rotation.x-d.y*0.003,-0.65,0.25)
