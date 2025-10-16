extends Camera3D

@onready var player
var fadedObjects = []
var originalObject = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $"../.."

func _process(delta):
	var space_state = get_world_3d().direct_space_state
	var params = PhysicsRayQueryParameters3D.new()
	params.from = global_transform.origin
	params.to = global_transform.origin
	params.collide_with_areas = false
	params.collide_with_bodies = true
	var result = space_state.intersect_ray(params)
	
	# Restore previous faded objects
	for obj in fadedObjects:
		reset_material(obj)
	fadedObjects.clear()

	if result and result.collider != player:
		fade_material(result.collider)
		fadedObjects.append(result.collider)

func  fade_material(obj):
	if obj == null:
		return
	var mesh_instance = obj as MeshInstance3D
	if mesh_instance == null:
		return
		
	if not originalObject.has(obj):
		originalObject[obj] = []
		for i in range(mesh_instance.get_surface_override_material_count()):
			var mat = mesh_instance.get_surface_override_material(i)
			originalObject[obj].append(mat)
			
	for i in range(mesh_instance.get_surface_override_material_count()):
		var mat = mesh_instance.get_surface_override_material(i)
		if mat == null:
			continue
		mat = mat.duplicate()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color.a = 0.3
		mesh_instance.set_surface_override_material(i, mat)


func reset_material(obj):
	if obj == null:
		return
	var mesh_instance = obj as MeshInstance3D
	if mesh_instance == null:
		return
	if originalObject.has(obj):
		var mats = originalObject[obj]
		for i in range(mesh_instance.get_surface_override_material_count()):
			if i < mats.size():
				mesh_instance.set_surface_override_material(i, mats[i])
			originalObject.erase(obj)
