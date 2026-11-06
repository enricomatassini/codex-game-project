extends Node3D
## Original procedural art for the prototype. World units are metres, Y is up.
## This node never changes physics or adds collision shapes.

const LEG_LENGTH := 1.35
var _legs: Array[Dictionary] = []
var _built := false


func build(table_body: RigidBody3D) -> void:
	if _built:
		return
	_built = true
	_build_lighting()
	_build_table(table_body)
	_build_garden()
	_build_legs()


func update_feet(positions: Array[Vector3], _delta: float) -> void:
	for i in range(mini(positions.size(), _legs.size())):
		var leg: Dictionary = _legs[i]
		var side: float = -1.0 if i == 0 else 1.0
		# Hips lie behind the supine camera, so thighs enter from the bottom
		# rather than looking like arms extending inwards from the side edges.
		var hip := Vector3(side * 0.18, -0.25, 1.25)
		var foot: Vector3 = positions[i]
		var ankle := foot + Vector3(0.0, -0.055, 0.08)
		var axis := ankle - hip
		var distance := axis.length()
		if distance < 0.001:
			continue
		axis /= distance
		# Knees fold mainly in the sagittal plane, with only slight splay.
		var bend := Vector3(side * 0.08, 0.0, 1.0)
		bend = (bend - axis * bend.dot(axis)).normalized()
		var half_distance := distance * 0.5
		# Normally feet stay below 2.8 m. Stretch only if another controller
		# exceeds reach: feet must still coincide exactly with physics centres.
		var length := maxf(LEG_LENGTH, half_distance + 0.001)
		var knee := (hip + ankle) * 0.5 + bend * sqrt(maxf(0.0, length * length - half_distance * half_distance))
		_place_segment(leg["thigh"], hip, knee)
		_place_segment(leg["shin"], knee, ankle)
		leg["knee"].global_position = knee
		leg["shoe"].global_position = foot
		leg["cuff"].global_position = ankle


func _material(color: Color, roughness: float = 0.6) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	return material


func _build_lighting() -> void:
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color("76bee1")
	sky_material.sky_horizon_color = Color("d4eaf0")
	sky_material.ground_bottom_color = Color("b9c9ad")
	sky_material.ground_horizon_color = Color("d4eaf0")
	sky_material.sky_curve = 0.22
	var sky := Sky.new()
	sky.sky_material = sky_material
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("e6eddf")
	environment.ambient_light_energy = 0.72
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	var world := WorldEnvironment.new()
	world.environment = environment
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.name = "AfternoonSun"
	sun.rotation_degrees = Vector3(-52.0, -32.0, 0.0)
	sun.light_color = Color("fff2d7")
	sun.light_energy = 1.05
	sun.shadow_enabled = true
	sun.directional_shadow_max_distance = 18.0
	sun.shadow_bias = 0.04
	add_child(sun)
	# A weak bounce light keeps the decorated underside readable from below.
	var bounce := DirectionalLight3D.new()
	bounce.name = "GardenBounce"
	bounce.rotation_degrees = Vector3(70.0, 25.0, 0.0)
	bounce.light_color = Color("e4eeec")
	bounce.light_energy = 0.38
	bounce.shadow_enabled = false
	add_child(bounce)


func _build_table(body: RigidBody3D) -> void:
	var red := _material(Color("ae3032"), 0.32)
	var dark_red := _material(Color("722326"), 0.46)
	var gold := _material(Color("e6bf75"), 0.40)
	gold.metallic = 0.22
	var lacquer := SurfaceTool.new()
	var frame := SurfaceTool.new()
	var ornament := SurfaceTool.new()
	for surface in [lacquer, frame, ornament]:
		surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	_box(lacquer, Vector3(1.4, 0.1, 1.4), Vector3.ZERO)
	# The underside at -Y faces the player; structural legs point towards +Y.
	for side in [-1.0, 1.0]:
		_box(frame, Vector3(1.28, 0.16, 0.065), Vector3(0.0, 0.12, side * 0.60))
		_box(frame, Vector3(0.065, 0.16, 1.28), Vector3(side * 0.60, 0.12, 0.0))
		_box(frame, Vector3(1.20, 0.045, 0.045), Vector3(0.0, 0.48, side * 0.58))
		_box(frame, Vector3(0.045, 0.045, 1.20), Vector3(side * 0.58, 0.48, 0.0))
		for other in [-1.0, 1.0]:
			_box(lacquer, Vector3(0.075, 0.70, 0.075), Vector3(side * 0.58, 0.40, other * 0.58))
			_box(ornament, Vector3(0.079, 0.065, 0.079), Vector3(side * 0.58, 0.70, other * 0.58))
	# Two thin original borders, a compass-flower and four corner fans.
	for inset in [0.61, 0.655]:
		for side in [-1.0, 1.0]:
			_box(ornament, Vector3(inset * 2.0, 0.003, 0.009), Vector3(0.0, -0.052, side * inset))
			_box(ornament, Vector3(0.009, 0.003, inset * 2.0), Vector3(side * inset, -0.052, 0.0))
	for ring in [0.21, 0.245]:
		for step in range(48):
			var a := TAU * float(step) / 48.0
			var b := TAU * float(step + 1) / 48.0
			_gold_line(ornament, Vector2(cos(a), sin(a)) * ring, Vector2(cos(b), sin(b)) * ring, 0.008)
	for petal in range(8):
		var angle := TAU * float(petal) / 8.0
		var direction := Vector2(cos(angle), sin(angle))
		var tangent := Vector2(-sin(angle), cos(angle))
		var inner := direction * 0.06
		var tip := direction * 0.17
		var centre := direction * 0.115
		_gold_line(ornament, inner, centre + tangent * 0.042, 0.010)
		_gold_line(ornament, centre + tangent * 0.042, tip, 0.010)
		_gold_line(ornament, tip, centre - tangent * 0.042, 0.010)
		_gold_line(ornament, centre - tangent * 0.042, inner, 0.010)
	for x in [-1.0, 1.0]:
		for z in [-1.0, 1.0]:
			var corner := Vector2(x, z) * 0.49
			for ray in range(5):
				var angle := float(ray) * PI / 8.0
				var finish := corner - Vector2(x * cos(angle), z * sin(angle)) * 0.17
				_gold_line(ornament, corner, finish, 0.008)
	_commit_surface(body, lacquer, red, "LacqueredWood")
	_commit_surface(body, frame, dark_red, "TableApronAndBraces")
	_commit_surface(body, ornament, gold, "OriginalGoldenFlower")


func _box(surface: SurfaceTool, size: Vector3, centre: Vector3, basis: Basis = Basis.IDENTITY) -> void:
	var box := BoxMesh.new()
	box.size = size
	surface.append_from(box, 0, Transform3D(basis, centre))


func _gold_line(surface: SurfaceTool, from: Vector2, to: Vector2, width: float) -> void:
	var difference := to - from
	var centre := (from + to) * 0.5
	var basis := Basis(Vector3.UP, -atan2(difference.y, difference.x))
	_box(surface, Vector3(difference.length(), 0.003, width), Vector3(centre.x, -0.053, centre.y), basis)


func _commit_surface(parent: Node3D, surface: SurfaceTool, material: Material, label: String) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = label
	instance.mesh = surface.commit()
	instance.material_override = material
	parent.add_child(instance)
	return instance


func _build_garden() -> void:
	var leaf := SphereMesh.new()
	leaf.radius = 1.0
	leaf.height = 2.0
	leaf.radial_segments = 12
	leaf.rings = 6
	var leaves := _material(Color("78a56b"), 0.95)
	var foliage := MultiMesh.new()
	foliage.transform_format = MultiMesh.TRANSFORM_3D
	foliage.use_colors = true
	foliage.mesh = leaf
	foliage.instance_count = 40
	var rng := RandomNumberGenerator.new()
	rng.seed = 4712
	for i in range(40):
		var side: float = -1.0 if i < 20 else 1.0
		var position := Vector3(side * rng.randf_range(3.7, 5.0), rng.randf_range(5.5, 9.5), rng.randf_range(-3.0, 4.2))
		var size := Vector3(rng.randf_range(0.60, 1.2), rng.randf_range(0.55, 0.95), rng.randf_range(0.7, 1.25))
		foliage.set_instance_transform(i, Transform3D(Basis.IDENTITY.scaled(size), position))
		foliage.set_instance_color(i, Color(0.65 + rng.randf() * 0.35, 0.77 + rng.randf() * 0.23, 0.58 + rng.randf() * 0.30))
	var canopy := MultiMeshInstance3D.new()
	canopy.name = "GardenCanopy"
	canopy.multimesh = foliage
	leaves.vertex_color_use_as_albedo = true
	canopy.material_override = leaves
	canopy.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(canopy)
	var cloud_material := _material(Color("daedf0"), 1.0)
	cloud_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var cloud_mesh := SphereMesh.new()
	cloud_mesh.radius = 1.0
	cloud_mesh.height = 2.0
	cloud_mesh.radial_segments = 32
	cloud_mesh.rings = 16
	var clouds := MultiMesh.new()
	clouds.transform_format = MultiMesh.TRANSFORM_3D
	clouds.mesh = cloud_mesh
	clouds.instance_count = 12
	for i in range(12):
		var cluster: int = i / 4
		var position := Vector3(-5.5 + float(cluster) * 5.8 + rng.randf_range(-0.9, 0.9), 24.0 + float(cluster) * 2.0, -7.0 + float(cluster) * 5.0 + rng.randf_range(-0.5, 0.5))
		var size := Vector3(rng.randf_range(0.8, 1.3), 0.22, rng.randf_range(0.5, 0.85))
		clouds.set_instance_transform(i, Transform3D(Basis.IDENTITY.scaled(size), position))
	var cloud_node := MultiMeshInstance3D.new()
	cloud_node.name = "SoftClouds"
	cloud_node.multimesh = clouds
	cloud_node.material_override = cloud_material
	cloud_node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(cloud_node)


func _build_legs() -> void:
	var trousers := _material(Color("eee0a5"), 0.88)
	var cloth_fold := _material(Color("d4c58f"), 0.94)
	var shoe_material := _material(Color("f7f0dc"), 0.74)
	var sole_material := _material(Color("c5c4ae"), 0.9)
	for i in range(2):
		var thigh := _limb(0.175, 0.14, trousers)
		var shin := _limb(0.14, 0.095, trousers)
		var knee_mesh := SphereMesh.new()
		knee_mesh.radius = 0.144
		knee_mesh.height = 0.288
		knee_mesh.radial_segments = 12
		knee_mesh.rings = 6
		var knee := _mesh_node(knee_mesh, trousers)
		var cuff_mesh := CylinderMesh.new()
		cuff_mesh.top_radius = 0.10
		cuff_mesh.bottom_radius = 0.105
		cuff_mesh.height = 0.055
		cuff_mesh.radial_segments = 12
		var cuff := _mesh_node(cuff_mesh, cloth_fold)
		var shoe := Node3D.new()
		shoe.name = "LeftShoe" if i == 0 else "RightShoe"
		add_child(shoe)
		var upper_mesh := CapsuleMesh.new()
		upper_mesh.radius = 0.13
		upper_mesh.height = 0.42
		upper_mesh.radial_segments = 12
		upper_mesh.rings = 6
		var upper := MeshInstance3D.new()
		upper.mesh = upper_mesh
		upper.material_override = shoe_material
		upper.rotation.x = PI * 0.5
		upper.scale = Vector3(1.0, 1.0, 0.46)
		shoe.add_child(upper)
		var detail := SurfaceTool.new()
		detail.begin(Mesh.PRIMITIVE_TRIANGLES)
		_box(detail, Vector3(0.235, 0.018, 0.35), Vector3(0.0, -0.045, 0.0))
		for lace in range(3):
			_box(detail, Vector3(0.13, 0.007, 0.012), Vector3(0.0, 0.055, -0.025 + float(lace) * 0.035))
		_commit_surface(shoe, detail, sole_material, "SoleAndLaces")
		_legs.append({"thigh": thigh, "shin": shin, "knee": knee, "shoe": shoe, "cuff": cuff})


func _mesh_node(mesh: Mesh, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.material_override = material
	add_child(instance)
	return instance


func _limb(bottom_radius: float, top_radius: float, material: Material) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.bottom_radius = bottom_radius
	mesh.top_radius = top_radius
	mesh.height = 1.0
	mesh.radial_segments = 12
	return _mesh_node(mesh, material)


func _place_segment(instance: Node3D, from: Vector3, to: Vector3) -> void:
	var direction := to - from
	var length := direction.length()
	var y := direction / maxf(length, 0.001)
	var x := Vector3.FORWARD.cross(y).normalized()
	if x.length_squared() < 0.01:
		x = Vector3.RIGHT
	var z := x.cross(y).normalized()
	instance.global_transform = Transform3D(Basis(x, y * length, z), (from + to) * 0.5)
