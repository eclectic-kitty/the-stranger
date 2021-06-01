extends Spatial
var test

var run = 0
var seen = 0 # Boolean variable to know if npc has been seen by player
onready var camera = get_viewport().get_camera() #This gets the active camera and its global position
signal disappeared(pos, bus_id) # This signal will alert other nodes of the NPC's disappearance

var in_screen # Variable for VisibilityNotifier to set to 1 or 0
var obscured # Variable that will contain outcome of ray tracing
var camera_dist # camera that will contain the distance between the camera and the npc

var pos = Vector3(15, 0, 0)
var rot = 0

var A = AudioServer
var clicked
var click_pos
var sounds = []
var bus_id
var bus_num

func _ready():
	# This sets the npc to the standing animation, but with speed at 0 so it stands still
	var anim = $Armature/AnimationPlayer
	anim.play("Standing", -1.0, 0.0)
	
	# This creates and sets up the NPC's unique audio bus
	#bus_num = A.get_bus_count()
	#A.add_bus(bus_num)
	#A.set_bus_name(bus_num, str(bus_id))
	#A.add_bus_effect(1, AudioEffectReverb.new(), 0)
	#var R = A.get_bus_effect(1, 0)
	#R.room_size = 0.7
	#R.damping = 0
	#R.hipass = 0.89
	#R.wet = 0.2
	#$Mouth.bus = str(2)
	#print($Mouth.bus)
	
	# This loads all the audio files for talking
	var dir = Directory.new()
	dir.open("res://audio/speech")
	dir.list_dir_begin(true, true)
	
	while true:
		var file = dir.get_next()
		#print(file)
		if file == "": 
			break
		elif not file.ends_with(".import"):
			var path = "res://audio/speech/" + file
			var res = load(path)
			sounds.append(res)

func _physics_process(_delta):
	var camera_pos = camera.get_global_transform().origin # This gets the camera's position
	camera_dist = self.translation.distance_to(camera_pos) # This calculates the distance to the camera/player
	
	var direct_state = get_world().direct_space_state # This is necessary for ray tracing
	
	# This determines if the NPC is being obscured in player's vision
	if in_screen: 
		obscured = direct_state.intersect_ray(self.translation, camera_pos, [], 1)
	
	# This deletes the NPC if it spawns inside a monolith or in view of the player, runs only at the beginning
	if run <= 5:
		run += 1
		var colliding = $Armature/RigidBody.get_colliding_bodies()
		if colliding: 
			disappear()
		elif in_view(): 
			disappear()
		elif run == 5: visible = true
	
	# This sets "seen" to 1 once the npc has been seen for the first time.
	if in_view() and not seen: 
		seen = 1
		#print("seen! ", self.translation)
	
	# This handles the NPC being clicked on and talking
	if in_view() and camera_dist < 5 and clicked:
		var from = camera.project_ray_origin(click_pos)
		var to = from + camera.project_ray_normal(click_pos) * 1000
		var click = direct_state.intersect_ray(from, to, [], 2)
		if click and click["collider"] == $Armature/RigidBody:
			$Mouth.set_stream(sounds[randi() % (sounds.size() - 1)])
			$Mouth.play(0.0)
			var playing = $Mouth.get_stream().get_name()
			print("Playing ", playing)
	clicked = 0
			
	# Manual attenuation for any noises the NPC might be making
	if camera_dist > 5:
		$Mouth.unit_db = -0.145 * pow((camera_dist - 5.0), 1.5)
	
	# After the npc has been seen, if the player loses sight of it, it is deleted
	if seen: 
		if not in_view():
			disappear()
	


# This function returns 1 if the enemy is visible and 0 if not
func in_view():
	if in_screen: if not obscured and camera_dist < 40:
		return 1
	else:
		return 0


# This function deletes the instance to make it siappear, as well as sending out the related signal
func disappear():
	#for i in 699:
		#A.get_bus_effect(0, 0).wet += 0.001
	emit_signal("disappeared", self.pos, self.bus_id)
	#print("Bye!")
	queue_free()


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		clicked = 1
		click_pos = event.position


# These two signals change "in_screen"
func _on_VisibilityNotifier_screen_entered():
	in_screen = 1

func _on_VisibilityNotifier_screen_exited():
	in_screen = 0
