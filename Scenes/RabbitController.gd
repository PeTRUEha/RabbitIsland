extends Node2D
class_name RabbitController

# Called when the node enters the scene tree for the first time.
var mating_rabbits_by_hole: Dictionary = {}
var mates_required: Array[RabbitHole] = []

func get_all_mating_rabbits() -> Array[Rabbit]:
	var rabbits: Array[Rabbit] = []
	for key in mating_rabbits_by_hole:
		rabbits.append_array(mating_rabbits_by_hole[key])
	return rabbits as Array[Rabbit]

func _on_rabbit_ready_to_mate(ready_rabbit: Rabbit, rabbit_hole: RabbitHole):
	print("got signal ready_to_mate ", ready_rabbit, " ", rabbit_hole)
	if rabbit_hole.name not in mating_rabbits_by_hole:
		mating_rabbits_by_hole[rabbit_hole.name] = []
	mating_rabbits_by_hole[rabbit_hole.name].append(ready_rabbit)
	add_more_maters_if_needed(rabbit_hole)


func call_another_rabbit(rabbit_hole: RabbitHole):
	var rabbits = get_children()
	var mating_rabbits = get_all_mating_rabbits()
	var candidate_rabbits = []
	for rabbit in rabbits:
		var state = rabbit.get_state()
		if state not in ["running_away_state", "mating_state"]:
			candidate_rabbits.append(rabbit)
	if candidate_rabbits:
		var nearest_rabbit: Rabbit = Globals.get_closest_node(rabbit_hole, candidate_rabbits)
		nearest_rabbit.go_mating(rabbit_hole)
	else:
		mates_required.append(rabbit_hole)
	
	
func _on_rabbit_no_longer_mating(rabbit: Rabbit, rabbit_hole: RabbitHole):
	print("got signal no_longer_mating ", rabbit, " ", rabbit_hole)
	mating_rabbits_by_hole[rabbit_hole.name].erase(rabbit)
	add_more_maters_if_needed(rabbit_hole)
	
func add_more_maters_if_needed(rabbit_hole: RabbitHole):
	var key = rabbit_hole.name
	if 0 < len(mating_rabbits_by_hole[key]) and len(mating_rabbits_by_hole[key]) < 2:
		call_another_rabbit(rabbit_hole)
	else:
		mates_required.erase(rabbit_hole)
