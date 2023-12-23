extends CharacterBody2D

@export var speed = 100
@export var acceleration = 2.5

@export var eating_time = 0.5
@export var eating_size = 5
@export var boundary_evasion_coefficient = 2000

var fullness = 0
var boundary_shapes_rid: Array[RID]

func move(direction_vector: Vector2, delta):
	var direction = direction_vector.normalized() 
	var desired_velocity =  direction * speed
	var acceleration_direction: Vector2 = desired_velocity - velocity
	var steering = (acceleration * acceleration_direction) * delta
	velocity += steering

	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true
		
	move_and_slide()

func get_boundary_evasion() -> Vector2:
	var boundary_detected = $BoundaryDetector.get_overlapping_bodies()
	var boundary_evasion = Vector2()
	if boundary_detected:
		var tile_map: TileMap = boundary_detected[0]
		for rid in boundary_shapes_rid:
			var coords = tile_map.to_global(tile_map.map_to_local(tile_map.get_coords_for_body_rid(rid)))
			var boundary_to_self_vector = global_position - coords
			var boundary_distance = boundary_to_self_vector.length()
			var coefficient = 1 / (boundary_distance + 50) - 0.005
			boundary_evasion += coefficient * boundary_to_self_vector.normalized()
	return boundary_evasion * boundary_evasion_coefficient


func die():
	$StateMachine.transition_state("DyingState")


func _on_predator_detector_body_entered(body):
	$StateMachine.transition_state("running_away_state", {'treat': body})


func _on_boundary_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	boundary_shapes_rid.append(body_rid)
	
	
func _on_boundary_detector_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	boundary_shapes_rid.erase(body_rid)
