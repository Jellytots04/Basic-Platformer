extends Area3D

@export var target_teleporter_path: NodePath
var player_on_teleporter = false

func _ready():
	self.connect("body_exited", Callable(self,"_on_body_exited"))
	self.connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_exited(body):
	print("Bye bye body")
	if body.name == "Player":
		player_on_teleporter = false
		body.set("is_on_teleporter", false)

func _on_body_entered(body):
	print("Hello Body")
	if body.name == "Player":
		body.currentTeleporter = self
		player_on_teleporter = true
		body.set("is_on_teleporter", true)

func teleport_player(player):
	var target_teleporter = get_node(target_teleporter_path)
	if target_teleporter:
		player.global_transform.origin = target_teleporter.global_transform.origin + Vector3(0, 0.05, 0)
