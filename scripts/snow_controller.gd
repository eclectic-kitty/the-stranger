extends Spatial


var player

var snow_scene = load("res://snow.tscn")

# Init function
func _ready():
	# Assigns player variable Player node
	player = $"../Player"
	
	# Creates first snow instance
	_on_SnowTimer_timeout()


# Creates new snow instances every 5 seconds on signal from SnowTimer node
func _on_SnowTimer_timeout():
	var snow = snow_scene.instance()
	
	var player_pos = player.translation
	snow.translation = player_pos
	
	add_child(snow)
