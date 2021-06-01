extends Spatial


var screen_size
var rng
var center = self.translation


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	rng = RandomNumberGenerator.new()
	rng.randomize()
	$Wind.play(rng.randi() % 938)
	print($Wind.get_playback_position())
		
	screen_size = get_viewport().size
	$Crosshair.rect_position.x = screen_size.x / 2 - $Crosshair.rect_size.x * $Crosshair.rect_scale.x / 2
	$Crosshair.rect_position.y = screen_size.y / 2 - $Crosshair.rect_size.y * $Crosshair.rect_scale.y / 2


func _process(_delta):
	var player_dist = $Player.translation.distance_to(center)
	if player_dist <= 250:
		#$Wind.volume_db = -0.08 * player_dist
		$Wind.volume_db = -0.00506 * pow(player_dist, 1.5)
		#$Wind.volume_db = -0.00032 * pow(player_dist, 2)
		#$Wind.volume_db = -0.00000128 * pow(player_dist, 3)


func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		if Input.get_mouse_mode() == 2:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("ui_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	
