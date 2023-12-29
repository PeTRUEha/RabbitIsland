extends Node

func get_closest_node(from: Node2D, bodies):
	var closest = bodies[0]
	var closest_distance = 10000000
	for body in bodies:
		var distance = from.global_position.distance_to(body.global_position)
		if  distance < closest_distance:
			closest_distance = distance
			closest = body
	return closest


func format_time(time: int) -> String:
	var minutes = int(time / 60)
	var seconds = str(time % 60)
	if len(seconds) == 1:
		seconds = '0' + seconds
	return str(minutes, ":", seconds)

