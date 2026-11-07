extends CharacterBody3D

const WALK_SPEED := 5.2
const SPRINT_SPEED := 7.4
const GROUND_ACCELERATION := 22.0
const AIR_ACCELERATION := 7.0
const GRAVITY := 18.0
const JUMP_VELOCITY := 4.5
const CAMERA_PITCH_MIN := -0.65
const CAMERA_PITCH_MAX := 0.25

var camera_pivot: Node3D
var camera: Camera3D
var mobile_move := Vector2.ZERO
var mobile_sprinting := false
var mobile_jump_requested := false

func _ready() -> void:
    _build_visual()
    _build_camera()

func _build_visual() -> void:
    var visual := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.42
    capsule.height = 1.8
    visual.mesh = capsule
    visual.position.y = 0.9
    var material := StandardMaterial3D.new()
    material.albedo_color = Color("283d55")
    visual.material_override = material
    add_child(visual)

    var collision := CollisionShape3D.new()
    var shape := CapsuleShape3D.new()
    shape.radius = 0.42
    shape.height = 1.8
    collision.shape = shape
    collision.position.y = 0.9
    add_child(collision)

func _build_camera() -> void:
    camera_pivot = Node3D.new()
    camera_pivot.position.y = 1.55
    add_child(camera_pivot)

    camera = Camera3D.new()
    camera.position = Vector3(0.0, 1.0, 5.8)
    camera.rotation_degrees.x = -12.0
    camera.current = true
    camera_pivot.add_child(camera)

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= GRAVITY * delta

    var jump_pressed := mobile_jump_requested or Input.is_action_just_pressed("jump")
    mobile_jump_requested = false
    if is_on_floor() and jump_pressed:
        velocity.y = JUMP_VELOCITY

    var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
    if input.length() < 0.05:
        input = mobile_move

    var camera_forward := -camera_pivot.global_basis.z
    var camera_right := camera_pivot.global_basis.x
    camera_forward.y = 0.0
    camera_right.y = 0.0
    camera_forward = camera_forward.normalized()
    camera_right = camera_right.normalized()

    var direction := (camera_right * input.x - camera_forward * input.y).normalized()
    var sprinting := mobile_sprinting or Input.is_action_pressed("sprint")
    var target_speed := SPRINT_SPEED if sprinting else WALK_SPEED
    var acceleration := GROUND_ACCELERATION if is_on_floor() else AIR_ACCELERATION

    var target_velocity := direction * target_speed
    velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
    velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)

    if direction.length() > 0.05:
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 9.0)

    move_and_slide()

func set_mobile_move(value: Vector2) -> void:
    mobile_move = value.limit_length(1.0)

func set_mobile_sprint(enabled: bool) -> void:
    mobile_sprinting = enabled

func request_jump() -> void:
    mobile_jump_requested = true

func rotate_camera(relative_motion: Vector2) -> void:
    camera_pivot.rotate_y(-relative_motion.x * 0.004)
    camera.rotation.x = clamp(
        camera.rotation.x - relative_motion.y * 0.003,
        CAMERA_PITCH_MIN,
        CAMERA_PITCH_MAX
    )

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        rotate_camera(event.relative)
    elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
