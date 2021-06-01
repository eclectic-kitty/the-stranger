extends Particles

var player
var player_pos

func _ready():
	player = $"../Player"

func _process(_delta):
	player_pos = player.translation
	self.translation = player_pos
