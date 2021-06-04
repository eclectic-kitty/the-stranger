extends KinematicBody


onready var camera = $Pivot/Camera

var gravity = -30
var max_speed = 6
var mouse_sensitivity = 0.003 #radians/pixel
var velocity = Vector3()

onready var player_pos = self.translation
const world_radius = 270
const edge_offset = 5


func _ready():
	pass


func get_input():
	var input_dir = Vector3()
	if Input.is_action_pressed("move_forward"):
		input_dir += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("strafe_left"):
		input_dir += -camera.global_transform.basis.x
	if Input.is_action_pressed("strafe_right"):
		input_dir += camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir


func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		#$Pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.5, 1.5)


# Teleport a player to the opposite side of the world when they reach the edge
func stitch_torus():
	player_pos = self.translation
	if abs(player_pos.x) > world_radius:
		self.translation.x = -(self.translation.x - edge_offset*(abs(self.translation.x)/self.translation.x)) 
	if abs(player_pos.z) > world_radius:
		self.translation.z = -(self.translation.z - edge_offset*(abs(self.translation.z)/self.translation.z)) 


func _physics_process(delta):
	velocity.y += gravity * delta
	var input_velocity = get_input() * max_speed
	
	velocity.x = input_velocity.x
	velocity.z = input_velocity.z
	
	stitch_torus()
	velocity = move_and_slide(velocity, Vector3.UP, true)
