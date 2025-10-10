extends CharacterBody3D

@onready var XCamera:Camera3D = $"CameraController3D/XCamera"
@onready var YCamera:Camera3D = $"CameraController3D/YCamera"
@onready var ZCamera:Camera3D = $CameraController3D/ZCamera
@onready var CameraNode:Node = $CameraController3D
var currentcamera:Camera3D
var suspend = false

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and !suspend:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and !YCamera.current:
		velocity.y = JUMP_VELOCITY

	currentcamera = CameraNode._what_is_active()
	if currentcamera == YCamera:
		suspend = true
	else:
		suspend = false
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if currentcamera == XCamera:
			print("Camera X is positive") # Side scroller camera view
			velocity.z = -direction.x * SPEED

		if currentcamera == YCamera:
			print("Camera Y is positive") # Top down view for the game
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

		if currentcamera == ZCamera:
			print("Camera Z is positive") # Think if this as the true view when you press w or up you walk forward
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
