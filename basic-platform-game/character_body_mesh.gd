extends Node

var imageArray:Array[Sprite3D] = []
var currentImage:Sprite3D
var activated_sprite:Sprite3D
@onready var _player_node:CharacterBody3D = $".."

func _ready() -> void:
	imageArray.append($XImage)
	imageArray.append($YImage)
	imageArray.append($ZImage)
	activated_sprite = imageArray[0]
	#imageArray[1].visible = false
	#imageArray[2].visible = false
	pass
	
func _deactivate_image(current:Sprite3D):
	current.visible = false
	
func _activate_image(index: int):
	imageArray[index].visible = true
	activated_sprite = imageArray[index]
	
func _input(event) -> void:
	if _player_node.is_on_floor():
		if event.is_action_pressed("Xcamera"):
			_deactivate_image(activated_sprite)
			_activate_image(0)
		if event.is_action_pressed("Ycamera"):
			_deactivate_image(activated_sprite)
			_activate_image(1)
		if event.is_action_pressed("Zcamera"):
			_deactivate_image(activated_sprite)
			_activate_image(2)
