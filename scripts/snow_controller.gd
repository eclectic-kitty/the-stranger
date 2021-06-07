extends Spatial


var player
var player_pos

var snow_scene = load("res://snow.tscn")


func _ready():
	player = $"../Player"
	var snow = snow_scene.instance()
	add_child(snow)

func _process(_delta):
	pass

func _on_SnowTimer_timeout():
	var snow = snow_scene.instance()
	
	player_pos = player.translation
	snow.translation = player_pos
	
	add_child(snow)
	
