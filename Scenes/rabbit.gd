extends CharacterBody2D

@export var speed = 100
@export var acceleration = 2.5

@export var eating_distance = 12 # How to scale it?
@export var eating_time = 0.5
@export var eating_size = 5

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

func die():
	$StateMachine.transition_state("DyingState")


func _on_predator_detector_body_entered(body):
	$StateMachine.transition_state("running_away_state", {'treat': body})


func _on_boundary_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	boundary_shapes_rid.append(body_rid)
	
	
func _on_boundary_detector_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	boundary_shapes_rid.erase(body_rid)
