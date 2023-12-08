extends Node

func get_closest_body(from: PhysicsBody2D, bodies: Array):
	var closest = bodies[0]
	var closest_distance = 10000000
	for body in bodies:
		var distance = from.global_position.distance_to(body.global_position)
		if  distance < closest_distance:
			closest_distance = distance
			closest = body
	return closest
