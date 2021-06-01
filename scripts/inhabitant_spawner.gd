extends Spatial


export var npc_quantity = 15
export var spawn_range = 200
var positions = []
var bus_ids = []
var rng

var npc_scene = load("res://inhabitant.tscn")


func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in npc_quantity:
		spawn_npc()


#func _process(delta):
#	pass


func _on_npc_disappeared(pos, bus_id):
	#print("Bye!")
	positions.erase(pos)
	bus_ids.erase(bus_id)
	spawn_npc()


func spawn_npc():
	var npc = npc_scene.instance()
	
	var pos
	var good_pos = 0
	while not good_pos:
		pos = Vector3(rng.randfn(0.0, spawn_range/2), 0, rng.randfn(0.0, spawn_range/2))
		if positions: 
			var pos_check = 1
			for t in positions.size():
				if pos.distance_to(positions[t]) < 20:
					pos_check = 0
			if pos_check == 1: 
				good_pos = 1
		else: 
			good_pos = 1
	positions.append(pos)
	npc.translation = pos
	npc.pos = pos
	npc.rotate_y(((randi() % 6283) / 1000.0))
	
	var bus_id
	var good_bus_id = 0
	while not good_bus_id:
		bus_id = rng.randi() % (npc_quantity * 5)
		var bus_id_check = 1
		if bus_ids:
			for t in bus_ids.size():
				if bus_id == bus_ids[t]:
					bus_id_check = 0
			if bus_id_check == 1:
				good_bus_id = 1
		else:
			good_bus_id = 1
	bus_ids.append(bus_id)
	npc.bus_id = bus_id
	
	add_child(npc)
	npc.connect("disappeared", self, "_on_npc_disappeared")
	#print("Hiya!")
