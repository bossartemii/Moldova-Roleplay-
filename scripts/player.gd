extends CharacterBody3D

signal interaction_message_changed(message: String)

const WALK_SPEED := 5.2
const SPRINT_SPEED := 7.4
const GRAVITY := 18.0
const JUMP_VELOCITY := 4.5
const INTERACTION_DISTANCE := 3.5
const JUMP_BUFFER_TIME := 0.15

var visual: MeshInstance3D
var camera_pivot: Node3D
var spring_arm: SpringArm3D
var camera: Camera3D

var mobile_move := Vector2.ZERO
var sprinting := false
var jump_buffer_timer := 0.0

var current_interaction_target: Node = null
var last_interaction_message: String = ""

func _ready() -> void:
	# 1. Mesh visiva (ruota indipendentemente dalla camera)
	visual = MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.radius = 0.42
	capsule.height = 1.8
	visual.mesh = capsule
	visual.position.y = 0.9
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("283d55")
	visual.material_override = material
	add_child(visual)

	# 2. Collisione
	var collision := CollisionShape3D.new()
	var capsule_shape := CapsuleShape3D.new()
	capsule_shape.radius = 0.42
	capsule_shape.height = 1.8
	collision.shape = capsule_shape
	collision.position.y = 0.9
	add_child(collision)

	# 3. Pivot e Telecamera
	camera_pivot = Node3D.new()
	camera_pivot.position.y = 1.55
	add_child(camera_pivot)

	spring_arm = SpringArm3D.new()
	spring_arm.spring_length = 5.0
	spring_arm.margin = 0.2
	spring_arm.position = Vector3(0.0, 0.2, 0.0)
	camera_pivot.add_child(spring_arm)

	camera = Camera3D.new()
	camera.current = true
	spring_arm.add_child(camera)

func _physics_process(delta: float) -> void:
	if jump_buffer_timer > 0.0:
		jump_buffer_timer -= delta

	if not is_on_floor():
		velocity.y -= GRAVITY * delta
	else:
		if jump_buffer_timer > 0.0:
			velocity.y = JUMP_VELOCITY
			jump_buffer_timer = 0.0

	# Input: combinazione tastiera + levetta mobile
	var input_vector := Input.get_vector("ui_left", "ui_right", "ui_down", "ui_up")
	if input_vector.length_squared() < 0.0025:
		input_vector = mobile_move

	# Vettori direzionali basati solo sulla rotazione orizzontale del pivot
	var cam_transform := camera_pivot.global_transform
	var forward := -cam_transform.basis.z
	var right := cam_transform.basis.x
	forward.y = 0.0
	right.y = 0.0
	forward = forward.normalized()
	right = right.normalized()

	var direction := (right * input_vector.x + forward * input_vector.y).normalized()
	var speed := SPRINT_SPEED if sprinting else WALK_SPEED

	if direction.length_squared() > 0.0025:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		# Ruota solo il modello visivo verso la direzione di marcia, MAI il nodo radice
		var target_angle := atan2(-direction.x, -direction.z)
		visual.rotation.y = lerp_angle(visual.rotation.y, target_angle, minf(delta * 12.0, 1.0))
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	move_and_slide()
	_update_interaction_target()

func _update_interaction_target() -> void:
	var space_state := get_world_3d().direct_space_state
	if space_state == null:
		current_interaction_target = null
		return

	var origin := global_position + Vector3(0.0, 1.3, 0.0)
	var look_direction := -camera.global_transform.basis.z
	var end := origin + (look_direction * INTERACTION_DISTANCE)

	var query := PhysicsRayQueryParameters3D.create(origin, end)
	query.exclude = [get_rid()]
	query.collide_with_areas = true
	query.collide_with_bodies = true

	var hit := space_state.intersect_ray(query)
	if hit.is_empty():
		current_interaction_target = null
		return

	var collider = hit.get("collider")
	current_interaction_target = _find_interactable(collider)

func _find_interactable(node: Node) -> Node:
	var current := node
	while current != null and current != get_tree().root:
		if current.has_meta("interaction_message") or current.has_meta("interaction_prompt"):
			return current
		current = current.get_parent()
	return null

func set_mobile_move(value: Vector2) -> void:
	mobile_move = value.limit_length(1.0)

func set_mobile_sprint(enabled: bool) -> void:
	sprinting = enabled

func request_jump() -> void:
	jump_buffer_timer = JUMP_BUFFER_TIME

func rotate_camera(relative_motion: Vector2) -> void:
	camera_pivot.rotate_y(-relative_motion.x * 0.004)
	spring_arm.rotation.x = clampf(spring_arm.rotation.x - relative_motion.y * 0.003, deg_to_rad(-60.0), deg_to_rad(25.0))

func get_interaction_prompt() -> String:
	if current_interaction_target == null:
		return ""
	return str(current_interaction_target.get_meta("interaction_prompt", "Interagisci"))

func try_interact() -> void:
	if current_interaction_target == null:
		return
	last_interaction_message = str(current_interaction_target.get_meta("interaction_message", "Non c'è nulla da fare qui."))
	interaction_message_changed.emit(last_interaction_message)
