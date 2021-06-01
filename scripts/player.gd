extends KinematicBody


onready var camera = $Pivot/Camera

var gravity = -30
var max_speed = 6
var mouse_sensitivity = 0.003 #radians/pixel
var velocity = Vector3()


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


func _physics_process(delta):
	velocity.y += gravity * delta
	var input_velocity = get_input() * max_speed
	
	velocity.x = input_velocity.x
	velocity.z = input_velocity.z
	
	velocity = move_and_slide(velocity, Vector3.UP, true)
