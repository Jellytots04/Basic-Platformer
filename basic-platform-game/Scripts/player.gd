extends CharacterBody3D

@onready var XCamera:Camera3D = $"CameraController3D/XCamera"
@onready var YCamera:Camera3D = $"CameraController3D/YCamera"
@onready var ZCamera:Camera3D = $CameraController3D/ZCamera
@onready var CameraNode:Node = $CameraController3D
@onready var ColorChecker:Area3D = $Colorchecker
@onready var ColliderChecker:Area3D = $Collidingchecker
@onready var timer:Timer = $Timer
var currentcamera:Camera3D
var suspend = false
# Variables to be used when moving camera views, move player to their last original X Y Z pos
var lastX: float
var lastY: float
var lastZ: float
var startingColor 
# Will be used to determine what color the player last stepped on
# Variables to be used when player is on a teleporter
var is_on_teleporter
var currentTeleporter

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _process(delta: float) -> void:
	pass

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
			# print("Camera X is positive") # Side scroller camera view
			velocity.z = -direction.x * SPEED

		if currentcamera == YCamera:
			# print("Camera Y is positive") # Top down view for the game
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

		if currentcamera == ZCamera:
			# print("Camera Z is positive") # Think if this as the true view when you press w or up you walk forward
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _ready() -> void:
	timer.start()
	timer.wait_time = 5 / 1
	timer.connect("timeout", _time_out)
	ColorChecker.body_entered.connect(_on_body_entered)
	ColorChecker.body_exited.connect(_on_body_exited)

func _input(event) -> void:
	if self.is_on_floor():
		if event.is_action_pressed("Xcamera"):
			# var target_X = -1
			# Incomplete solution
			lastX = self.global_position.x
			#print("Before Changes Collider now at : ", ColliderChecker.global_position.x)
			#if _check_clear_X(target_X):
				#print("Checks out")
				#self.global_position.x  = target_X
				#ColliderChecker.global_position.x = target_X
			#else:
				#self.global_position.x = lastX
				#ColliderChecker.global_position.x = lastX
				#print("Passage is blocked")
			
			# --- New method idea --- 
			print("Before X change", self.global_position.x)
			self.global_position.x = _check_closest_X(self.global_position.x)
			print("New X", self.global_position.x)
			
		if event.is_action_pressed("Ycamera") and currentcamera == XCamera:
			self.global_position.x = lastX
			
		if event.is_action_pressed("Zcamera") and currentcamera == XCamera:
			self.global_position.x = lastX
			
	if is_on_teleporter and event.is_action_pressed("ui_accept") and currentcamera == YCamera:
		currentTeleporter.teleport_player(self)
	
# Used for comparing values with the users current X location to then get the closer value
func _check_closest_X(current_X: float) -> float:
	var grouping = [-1.5, -0.5, 0.5, 1.5]
	var closest = grouping[0]
	var min_diff = abs(current_X - closest)
	for value in grouping:
		var diff = abs(current_X - value)
		if diff < min_diff:
			min_diff = diff
			closest = value
	return closest

# To be finished later
func _check_clear_X(target_X: int) -> bool: # Will be used to check if the player has space to go to X camera mode
	ColliderChecker.global_position.x = target_X
	print("First Change: ", ColliderChecker.global_position.x)
	var overlap = ColliderChecker.get_overlapping_bodies()
	print(overlap) # Array of the overlapping bodies
	for body in overlap:
		print(body)
		if body != self:
			return false
	return true

func _on_body_entered(body: Node) -> void:
	if body != self or body.is_ancestor_of(self):
		# print("Stepped on:", body.name)
		_last_color_used(body)
	else:
		return

func _on_body_exited(body: Node) -> void:
	if body != self or body.is_ancestor_of(self):
		# print("Left:", body.name)
		pass
	
func _last_color_used(body: Node) -> void:
	# Your logic for color checking here, with access to the body node
	print("Stepping on something:", body.name)
	pass

func _time_out() -> void:
	print("located at ",self.global_position.x)

func _on_timer_timeout() -> void:
	# print(self.global_position.x)
	pass # Replace with function body.
