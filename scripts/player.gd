extends KinematicBody


onready var camera = $Pivot/Camera

# Movement variables
var gravity = -30
var max_speed = 6
var mouse_sensitivity = 0.003 # in radians/pixel
var velocity = Vector3()

# World looping variables
const world_radius = 260
const edge_offset = 5

# Footstep sounds array
var step_sounds = []


# Loads footstep sound files as resources
func _ready():
	var step_files = load("res://scripts/files.gd").new()
	step_sounds = step_files.list_files("res://audio/footsteps/")


# Gets direction of movement from player input
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


# Rotates camera and forward direction based on mouse input
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		#$Pivot.rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.5, 1.5)


# Teleports a player to the opposite side of the world at a certain distance from the edge 
# & calls a function on snow particle effects to teleport with the player
func stitch_torus():
	var old_pos = self.translation
	
	if abs(self.translation.x) > world_radius:
		self.translation.x = -(self.translation.x - edge_offset*(abs(self.translation.x)/self.translation.x))
		get_tree().call_group("snows", "teleport_to_player", old_pos, self.translation)
		
	if abs(self.translation.z) > world_radius:
		self.translation.z = -(self.translation.z - edge_offset*(abs(self.translation.z)/self.translation.z))
		get_tree().call_group("snows", "teleport_to_player", old_pos, self.translation)


# Moves player every physics frame
func _physics_process(delta):
	velocity.y += gravity * delta
	var input_velocity = get_input() * max_speed
	
	velocity.x = input_velocity.x
	velocity.z = input_velocity.z
	
	stitch_torus()
	velocity = move_and_slide(velocity, Vector3.UP, true)

	# Plays footstep when player is walking, and starts a timer that
	# inhibits footsteps for its duration.
	if velocity.z and $FootstepsTimer.is_stopped():
		$Footsteps.set_stream(step_sounds[randi() % (step_sounds.size())])
		$Footsteps.play(0)
		$FootstepsTimer.start()
