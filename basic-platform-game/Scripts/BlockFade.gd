extends Camera3D

@onready var player
var fadedObjects = []
var originalObject = {}

func _ready() -> void:
	player = $"../.." # Or use get_parent().get_parent() if needed

func _process(delta):
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = global_transform.origin
	params.to = player.global_transform.origin
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var results = []
	
	if self.current:
		results = get_all_ray_hits(params, 10) # Returns the objects.
	
	# Restore previous faded objects
	for obj in fadedObjects:
		reset_material(obj)
	fadedObjects.clear()
	
	for result in results:
		if result and result.collider != player:
			print("Collider hit:", result.collider)
			fade_material(result.collider)
			fadedObjects.append(result.collider)

func fade_material(obj):
	var mesh_instance = get_mesh_instance(obj)

	if mesh_instance == null:
		return
	print("Mesh:", mesh_instance.mesh)
	print("Surface count:", mesh_instance.mesh.get_surface_count())
	for i in range(mesh_instance.mesh.get_surface_count()):
		var mat_override = mesh_instance.get_surface_override_material(i)
		var mat_base = mesh_instance.mesh.surface_get_material(i)
		print("Surface ", i, "Override material:", mat_override)
		print("Surface ", i, "Base material:", mat_base)
		
	var mesh = mesh_instance.mesh
	if mesh == null:
		return

	if not originalObject.has(obj):
		originalObject[obj] = []
		var surface_count = mesh.get_surface_count()
		# print(surface_count)
		for i in range(surface_count):
			var mat = mesh_instance.get_surface_override_material(i)
			originalObject[obj].append(mat)

	var Surface_count = originalObject[obj].size()
	print("Surface_count original object ", Surface_count)

	for i in range(Surface_count):
		print("first i ",i)
		var mat = mesh_instance.get_surface_override_material(i)
		print("mat", mat)
		if mat == null:
			continue
			# mat = mesh_instance.mesh.surface_get_material(i)
		mat = mat.duplicate()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color.a = 0.3
		mesh_instance.set_surface_override_material(i, mat)
		print("later i ", i)

func reset_material(obj):
	var mesh_instance = get_mesh_instance(obj)
	if mesh_instance == null:
		return
	
	var mesh = mesh_instance.mesh
	if mesh == null:
		return

	if originalObject.has(obj):
		var mats = originalObject[obj]
		var surface_count = mesh.get_surface_count()
		for i in range(surface_count):
			if i < mats.size():
				mesh_instance.set_surface_override_material(i, mats[i])
		originalObject.erase(obj)

func get_mesh_instance(node):
	if node is MeshInstance3D:
		return node
	
	for child in node.get_children():
		var mesh_instance= get_mesh_instance(child)
		if mesh_instance != null:
			return mesh_instance
	
	return null

func get_all_ray_hits(params: PhysicsRayQueryParameters3D, max_hits: int = 10) -> Array:
	var results = []
	var exclude = []
	var start = params.from
	var end = params.to
	var direction = (end - start).normalized()
	
	for i in range(max_hits):
		params.from = start
		params.to = end
		params.exclude = exclude

		var result = get_world_3d().direct_space_state.intersect_ray(params)
		if result == null or not result.has("collider"):
			break

		results.append(result)
		exclude.append(result["collider"])

		start = result.position + direction * 0.01

	return results
