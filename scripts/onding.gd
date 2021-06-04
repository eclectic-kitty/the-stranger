extends Spatial


# Size of the screen, in pixels
var screen_size 
# Random number generator
var rng 
# Center of map, set to translation of root node
var center = self.translation 


func _ready():
	# Captures the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Plays ambient wind sounds, starting at random position
	rng = RandomNumberGenerator.new()
	rng.randomize()
	$Wind.play(rng.randi() % 938)
	
	# Sets the crosshair position
	screen_size = get_viewport().size
	$Crosshair.rect_position.x = screen_size.x / 2 - $Crosshair.rect_size.x * $Crosshair.rect_scale.x / 2
	$Crosshair.rect_position.y = screen_size.y / 2 - $Crosshair.rect_size.y * $Crosshair.rect_scale.y / 2


func _process(_delta):
	# Attenuates wind sound, based on player distance from center
	var player_dist = $Player.translation.distance_to(center)
	if player_dist <= 250:
		$Wind.volume_db = -0.00506 * pow(player_dist, 1.5)


func _input(_event):
	# Lets go and recaptures mouse
	if Input.is_action_just_pressed("ui_accept"):
		if Input.get_mouse_mode() == 2:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Goes in and out of fullscreen
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	#Quits game
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
