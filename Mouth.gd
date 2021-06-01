extends AudioStreamPlayer3D


# Declare member variables here. Examples:
var curr_state
var last_state


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	curr_state = self.playing
	if not curr_state == last_state:
		print("Changed!")
	last_state = curr_state
