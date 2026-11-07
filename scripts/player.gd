extends CharacterBody3D

signal interaction_message_changed(message: String)

const WALK_SPEED := 5.2
const SPRINT_SPEED := 7.4
const GRAVITY := 18.0
const JUMP_VELOCITY := 4.5
const INTERACTION_DISTANCE := 4.2

var camera_pivot: Node3D
var camera: Camera3D
var mobile_move := Vector2.ZERO
var sprinting := false
var jump_requested := false
var last_interaction_message := ""
var _last_target_id := 0

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

func get_interaction_prompt() -> String:
    var target := _get_interaction_target()
    if target == null:
        return ""
    return str(target.get_meta("interaction_prompt", "Interagisci"))

func try_interact() -> void:
    var target := _get_interaction_target()
    if target == null:
        return
    last_interaction_message = str(target.get_meta("interaction_message", "Non c'è nulla da fare qui."))
    interaction_message_changed.emit(last_interaction_message)

func _get_interaction_target() -> Node:
    if camera == null or not is_inside_tree():
        return null
    var origin := camera.global_position
    var end := origin + (-camera.global_basis.z * INTERACTION_DISTANCE)
    var query := PhysicsRayQueryParameters3D.create(origin, end)
    query.exclude = [get_rid()]
    var hit := get_world_3d().direct_space_state.intersect_ray(query)
    if hit.is_empty():
        return null
    var collider = hit.get("collider")
    if collider is Node and collider.has_meta("interaction_message"):
        return collider
    return null
