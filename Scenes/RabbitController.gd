extends Node2D
class_name RabbitController

# Called when the node enters the scene tree for the first time.
var mating_rabbits_by_hole: Dictionary = {}

func get_all_mating_rabbits() -> Array[Rabbit]:
	var rabbits: Array[Rabbit] = []
	for key in mating_rabbits_by_hole:
		rabbits.append_array(mating_rabbits_by_hole[key])
	return rabbits as Array[Rabbit]

func _on_rabbit_ready_to_mate(ready_rabbit: Rabbit, rabbit_hole: RabbitHole):
	print("got signal ", ready_rabbit, " ", rabbit_hole)
	
	if rabbit_hole.name not in mating_rabbits_by_hole:
		mating_rabbits_by_hole[rabbit_hole.name] = []
	mating_rabbits_by_hole[rabbit_hole.name].append(ready_rabbit)

	if len(mating_rabbits_by_hole[rabbit_hole.name]) < 2:
		call_another_rabbit(rabbit_hole)

func call_another_rabbit(rabbit_hole: RabbitHole):
	var rabbits = get_children()
	var mating_rabbits = get_all_mating_rabbits()
	var candidate_rabbits = []
	for rabbit in rabbits:
		if rabbit in mating_rabbits:
			continue
		if rabbit.get_state() == "running_away_state":
			continue
		candidate_rabbits.append(rabbit)
	var nearest_rabbit: Rabbit = Globals.get_closest_node(rabbit_hole, candidate_rabbits)
	nearest_rabbit.go_mating(rabbit_hole)
	
	
func _on_rabbit_no_longer_mating(rabbit: Rabbit, rabbit_hole: RabbitHole):
	mating_rabbits_by_hole[rabbit_hole.name].erase(rabbit)
