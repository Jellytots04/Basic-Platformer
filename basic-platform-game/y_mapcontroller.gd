extends Node3D

@onready var YCamera:Camera3D = $"../../Player/CameraController3D/YCamera"
@onready var CameraController:Node3D = $"../../Player/CameraController3D"

#func _ready() -> void:
	#$StageLevel/MeshInstance3D.visible = false
	#$StageLevel/CollisionShape3D.disabled = true
	

func _process(delta: float) -> void:
	if CameraController._what_is_active() == YCamera:
		$StageLevel/MeshInstance3D.visible = true
		$StageLevel/CollisionShape3D.disabled = false
	else:
		$StageLevel/MeshInstance3D.visible = false
		$StageLevel/CollisionShape3D.disabled = true
	pass
