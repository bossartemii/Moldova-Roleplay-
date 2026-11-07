extends CharacterBody3D

const WALK_SPEED := 5.2
const SPRINT_SPEED := 7.4
const GRAVITY := 18.0
const JUMP_VELOCITY := 4.5

var camera_pivot: Node3D
var camera: Camera3D
var mobile_move := Vector2.ZERO
var sprinting := false
var jump_requested := false

func _ready() -> void:
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
    var capsule_shape := CapsuleShape3D.new()
    capsule_shape.radius = 0.42
    capsule_shape.height = 1.8
    collision.shape = capsule_shape
    collision.position.y = 0.9
    add_child(collision)

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
    elif jump_requested:
        velocity.y = JUMP_VELOCITY
    jump_requested = false

    var input_vector := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    if input_vector.length_squared() < 0.0025:
        input_vector = mobile_move

    # Movement follows the camera yaw, as expected from a third-person mobile game.
    var camera_basis := camera_pivot.global_transform.basis
    var forward := -camera_basis.z
    var right := camera_basis.x
    forward.y = 0.0
    right.y = 0.0
    var direction := (right.normalized() * input_vector.x + forward.normalized() * input_vector.y).normalized()

    var speed := SPRINT_SPEED if sprinting else WALK_SPEED
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed

    if direction.length_squared() > 0.0025:
        var target_angle := atan2(-direction.x, -direction.z)
        rotation.y = lerp_angle(rotation.y, target_angle, minf(delta * 9.0, 1.0))

    move_and_slide()

func set_mobile_move(value: Vector2) -> void:
    mobile_move = value.limit_length(1.0)

func set_mobile_sprint(enabled: bool) -> void:
    sprinting = enabled

func request_jump() -> void:
    if is_on_floor():
        jump_requested = true

func rotate_camera(relative_motion: Vector2) -> void:
    camera_pivot.rotate_y(-relative_motion.x * 0.004)
    camera.rotation.x = clampf(camera.rotation.x - relative_motion.y * 0.003, -0.65, 0.25)
