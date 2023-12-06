extends CharacterBody2D

@export var speed = 100
@export var acceleration = 2.5

@export var eating_distance = 12 # How to scale it?
@export var eating_time = 0.5
@export var eating_size = 5

enum {
	SEARCHING_FOR_FOOD,
	CHASING_FOOD,
	RUNNING_FOR_LIFE,
	EATING
}

var fox: CharacterBody2D = null
var target_carrot: StaticBody2D = null
var state = SEARCHING_FOR_FOOD
var fullness = 0

func _ready():
	pass # Replace with function body.

func _process(delta):
	match state:
		SEARCHING_FOR_FOOD:
			var carrots = $CarrotDetector.get_overlapping_bodies()
			if carrots:
				state = CHASING_FOOD
				target_carrot = get_closest_carrot(carrots)
			else:
				$AnimationPlayer.play("idle")
				
		RUNNING_FOR_LIFE:
			var run_away_vector = global_position - fox.global_position
			move(global_position + run_away_vector, delta)
			
		CHASING_FOOD:
			if is_instance_valid(target_carrot):
				move(target_carrot.global_position, delta)
				var distance = global_position.distance_to(target_carrot.global_position)
				if distance < eating_distance:
					state=EATING
					target_carrot.be_eaten()
					create_tween().tween_callback(
						finish_eating.bind(target_carrot)
					).set_delay(eating_time)
					
			else:
				state = SEARCHING_FOR_FOOD

		EATING:
			$AnimationPlayer.play("eat")
		
func finish_eating(carrot: Carrot):
	carrot.remove_eater()
	if state == EATING:
		carrot.decrease_food(eating_size)
		fullness += eating_size
		state = SEARCHING_FOR_FOOD
	

func move(target: Vector2, delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * speed
	var acceleration_direction: Vector2 = desired_velocity - velocity
	var steering = (acceleration * acceleration_direction) * delta
	velocity += steering

	if direction.x > 0:
		$Sprite2D.flip_h = false
	elif direction.x < 0:
		$Sprite2D.flip_h = true
		
	move_and_slide()
	$AnimationPlayer.play("walking")


func get_closest_carrot(carrots: Array[Node2D]) -> StaticBody2D:
	var closest_carrot = carrots[0]
	var closest_distance = 10000000
	for carrot in carrots:
		var distance = global_position.distance_to(carrot.global_position)
		if  distance < closest_distance:
			closest_distance = distance
			closest_carrot = carrot
	return closest_carrot
		
	

func _on_fox_detector_body_entered(body):
	state = RUNNING_FOR_LIFE
	fox = body
	
func _on_fox_detector_body_exited(body):
	state = SEARCHING_FOR_FOOD
	fox = null
