extends Node

var CameraArray:Array[Camera3D] = []
var currentCamera:Camera3D
@onready var _player_node:CharacterBody3D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CameraArray.append($XCamera)
	CameraArray.append($YCamera)
	CameraArray.append($ZCamera)
	currentCamera = CameraArray[0]
	pass # Replace with function body.

func _deactivate_camera(current: Camera3D):
	current.current = false

func _active_camera(index: int):
	CameraArray[index].current = true
	var actived_camera = CameraArray[index]
	return actived_camera

func _input(event) -> void:
	if _player_node.is_on_floor():
		if event.is_action_pressed("Xcamera"):
			_deactivate_camera(currentCamera)
			_active_camera(0)
			currentCamera = CameraArray[0]
		if event.is_action_pressed("Ycamera"):
			_deactivate_camera(currentCamera)
			_active_camera(1)
			currentCamera = CameraArray[1]
		if event.is_action_pressed("Zcamera"):
			_deactivate_camera(currentCamera)
			_active_camera(2)
			currentCamera = CameraArray[2]

func _what_is_active():
	return currentCamera

func _camera_change(): # Can be used later for when camera swaps
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
