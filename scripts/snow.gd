extends Particles


# Called when the player loops around map, moves snow with player
func teleport_to_player(old_pos, new_pos):
	var difference = self.translation - old_pos
	self.translation = (new_pos + difference)


# Deletes node when particle effect is finished
func _on_DeathTimer_timeout():
	queue_free()
