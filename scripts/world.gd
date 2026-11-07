extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/player.gd")
const HUD_SCRIPT = preload("res://scripts/mobile_hud.gd")

func _ready() -> void:
	_setup_environment()
	_build_city_blockout()
	var player := _spawn_player()
	_spawn_hud(player)

func _setup_environment() -> void:
	var env_node := WorldEnvironment.new()
	var env := Environment.new()
	
	env.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = Color(0.38, 0.55, 0.78)
	sky_mat.sky_horizon_color = Color(0.72, 0.78, 0.86)
	sky_mat.ground_bottom_color = Color(0.2, 0.22, 0.25)
	sky.sky_material = sky_mat
	env.sky = sky
	
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_sky_contribution = 0.45
	env_node.environment = env
	add_child(env_node)

	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -28, 0)
	sun.light_energy = 1.2
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 120.0
	add_child(sun)

func _build_city_blockout() -> void:
	# Terreno e arterie stradali
	_box("Ground", Vector3(0, -0.25, 0), Vector3(260, 0.5, 260), Color("66745f"))
	_box("Stefan_cel_Mare_Boulevard", Vector3(0, 0.04, 0), Vector3(18, 0.08, 220), Color("30363b"))
	_box("Central_Street", Vector3(0, 0.05, 0), Vector3(220, 0.08, 18), Color("30363b"))

	# Marciapiedi
	_box("Boulevard_Sidewalk_Left", Vector3(-10.5, 0.12, 0), Vector3(3, 0.24, 220), Color("aaa69d"))
	_box("Boulevard_Sidewalk_Right", Vector3(10.5, 0.12, 0), Vector3(3, 0.24, 220), Color("aaa69d"))
	_box("Central_Sidewalk_North", Vector3(0, 0.13, -10.5), Vector3(220, 0.24, 3), Color("aaa69d"))
	_box("Central_Sidewalk_South", Vector3(0, 0.13, 10.5), Vector3(220, 0.24, 3), Color("aaa69d"))

	# Linee stradali (Mesh visive pure senza collisione fisica)
	for z: int in range(-96, 100, 16):
		_visual_box(Vector3(0, 0.09, float(z)), Vector3(0.22, 0.01, 7.0), Color("e7dfbd"))
	for x: int in range(-96, 100, 16):
		_visual_box(Vector3(float(x), 0.10, 0), Vector3(7.0, 0.01, 0.22), Color("e7dfbd"))

	# Edifici: array staticamente tipizzati per evitare errori di inferenza GDScript
	var positions: Array[Vector3] = [
		Vector3(-28, 8, -27), Vector3(28, 11, -27),
		Vector3(-28, 9, 28), Vector3(28, 13, 28),
		Vector3(-62, 10, -28), Vector3(62, 12, -28),
		Vector3(-62, 8, 28), Vector3(62, 9, 28)
	]
	var colors: Array[Color] = [
		Color("c8b9a2"), Color("b7c0c5"), Color("d0c7b8"), Color("9ea9a5")
	]
	
	for i: int in positions.size():
		var pos: Vector3 = positions[i]
		_box("Apartment_Block_%02d" % i, pos, Vector3(18, pos.y * 2.0, 19), colors[i % colors.size()])
		_add_windows(pos, i)

	# Piazza Civica e Municipio
	_box("Civic_Square", Vector3(0, 0.16, -52), Vector3(52, 0.25, 34), Color("b9b3a8"))
	_box("Civic_Hall_Blockout", Vector3(0, 8, -72), Vector3(25, 16, 12), Color("d4c8b4"))
	
	_add_street_furniture()
	_add_trees()

func _add_windows(building_position: Vector3, index: int) -> void:
	var window_material := Color("526a78") if index % 2 == 0 else Color("465d69")
	var z_offset := 9.55 if building_position.z < 0 else -9.55
	
	for floor_index: int in range(2, 6):
		for column: int in range(-2, 3):
			_visual_box(
				Vector3(
					building_position.x + float(column) * 2.8,
					float(floor_index) * 2.5,
					building_position.z + z_offset
				),
				Vector3(1.5, 1.15, 0.12),
				window_material
			)

func _add_street_furniture() -> void:
	var sides: Array[float] = [-1.0, 1.0]
	for z: int in range(-80, 81, 32):
		for side: float in sides:
			var x := side * 12.5
			_box("Lamp_Post_%d_%d" % [int(x), z], Vector3(x, 3.0, float(z)), Vector3(0.18, 6.0, 0.18), Color("343a3d"))
			_visual_box(Vector3(x, 6.0, float(z)), Vector3(1.0, 0.18, 0.35), Color("d9d2b4"))

	_interactive_box(
		"Bus_Stop_Information",
		Vector3(10.5, 1.35, 13.0),
		Vector3(0.22, 2.5, 1.25),
		Color("245b75"),
		"FERMATA AUTOBUS — Tocca USA",
		"Fermata Centru. Linea 1: Centru → Botanica. Frequenza stimata: 12 min."
	)
	
	_interactive_box(
		"Municipal_Information",
		Vector3(0, 1.3, -48.0),
		Vector3(1.8, 2.2, 0.25),
		Color("8b6a3e"),
		"INFORMAZIONI MUNICIPALI — Tocca USA",
		"Primăria Chișinău: Registri civici, catasto e sportello permessi commerciali."
	)

func _add_trees() -> void:
	var tree_points: Array[Vector3] = [
		Vector3(-15, 0, -35), Vector3(15, 0, -35),
		Vector3(-15, 0, 35), Vector3(15, 0, 35),
		Vector3(-18, 0, -62), Vector3(18, 0, -62)
	]
	
	for point: Vector3 in tree_points:
		var trunk := StaticBody3D.new()
		trunk.position = point + Vector3(0, 1.3, 0)
		
		var mi := MeshInstance3D.new()
		var trunk_mesh := CylinderMesh.new()
		trunk_mesh.top_radius = 0.2
		trunk_mesh.bottom_radius = 0.26
		trunk_mesh.height = 2.6
		mi.mesh = trunk_mesh
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color("6b4d35")
		mi.material_override = mat
		trunk.add_child(mi)
		
		var cs := CollisionShape3D.new()
		var col_shape := CylinderShape3D.new()
		col_shape.radius = 0.26
		col_shape.height = 2.6
		cs.shape = col_shape
		trunk.add_child(cs)
		add_child(trunk)

		var crown := MeshInstance3D.new()
		var crown_mesh := SphereMesh.new()
		crown_mesh.radius = 1.45
		crown_mesh.height = 2.8
		crown.mesh = crown_mesh
		var c_mat := StandardMaterial3D.new()
		c_mat.albedo_color = Color("456b49")
		crown.material_override = c_mat
		crown.position = point + Vector3(0, 3.0, 0)
		add_child(crown)

func _spawn_player() -> CharacterBody3D:
	var player := CharacterBody3D.new()
	player.name = "LocalPlayer"
	player.set_script(PLAYER_SCRIPT)
	player.position = Vector3(10.5, 1.2, 22.0)
	add_child(player)
	return player

func _spawn_hud(player_ref: CharacterBody3D) -> void:
	var layer := CanvasLayer.new()
	var hud := Control.new()
	hud.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	hud.set_script(HUD_SCRIPT)
	hud.set("player", player_ref)
	layer.add_child(hud)
	add_child(layer)

func _box(n: String, p: Vector3, s: Vector3, c: Color) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = n
	body.position = p
	
	var mi := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = s
	mi.mesh = mesh
	
	var mat := StandardMaterial3D.new()
	mat.albedo_color = c
	mi.material_override = mat
	body.add_child(mi)
	
	var cs := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = s
	cs.shape = shape
	body.add_child(cs)
	
	add_child(body)
	return body

func _visual_box(p: Vector3, s: Vector3, c: Color) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.position = p
	var mesh := BoxMesh.new()
	mesh.size = s
	mi.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = c
	mi.material_override = mat
	add_child(mi)
	return mi

func _interactive_box(n: String, p: Vector3, s: Vector3, c: Color, prompt: String, message: String) -> void:
	var body := _box(n, p, s, c)
	body.set_meta("interaction_prompt", prompt)
	body.set_meta("interaction_message", message)
