extends Node2D
class_name RabbitController

# Called when the node enters the scene tree for the first time.
var mating_fullness_theshold = 100
var mating_rabbits_by_hole: Dictionary = {}
var mates_required: Array[RabbitHole] = []

func get_all_mating_rabbits() -> Array[Rabbit]:
	var rabbits: Array[Rabbit] = []
	for key in mating_rabbits_by_hole:
		rabbits.append_array(mating_rabbits_by_hole[key])
	return rabbits as Array[Rabbit]

func _on_rabbit_ready_to_mate(ready_rabbit: Rabbit, rabbit_hole: RabbitHole):
	if rabbit_hole.name not in mating_rabbits_by_hole:
		mating_rabbits_by_hole[rabbit_hole.name] = []
	mating_rabbits_by_hole[rabbit_hole.name].append(ready_rabbit)
	add_more_maters_if_needed(rabbit_hole)


func call_another_rabbit(rabbit_hole: RabbitHole):
	var rabbits = get_children()
	var candidate_rabbits = []
	for rabbit in rabbits:
		var state = rabbit.get_state()
		if state not in ["running_away_state", "mating_state", "dying_state"]:
			candidate_rabbits.append(rabbit)
	if candidate_rabbits:
		var nearest_rabbit: Rabbit = Globals.get_closest_node(rabbit_hole, candidate_rabbits)
		nearest_rabbit.go_mating(rabbit_hole)
	else:
		mates_required.append(rabbit_hole)
	
	
func _on_rabbit_no_longer_mating(rabbit: Rabbit, rabbit_hole: RabbitHole):
	var hole_mating_rabbits = mating_rabbits_by_hole[rabbit_hole.name]
	hole_mating_rabbits.erase(rabbit)
	if is_enough_food_for_mating(rabbit_hole):
		add_more_maters_if_needed(rabbit_hole)
	#else:
		#for hole_rabbit in hole_mating_rabbits:
			#rabbit.cancel_mating()
	
func add_more_maters_if_needed(rabbit_hole: RabbitHole):
	var key = rabbit_hole.name
	if len(mating_rabbits_by_hole[key]) == 1:
		call_another_rabbit(rabbit_hole)
	else:
		mates_required.erase(rabbit_hole)

func is_enough_food_for_mating(hole: RabbitHole) -> bool:
	var hole_mating_rabbits = mating_rabbits_by_hole[hole.name]
	for hole_rabbit in hole_mating_rabbits:
		if hole_rabbit.fullness > mating_fullness_theshold:
			return true
	return false
