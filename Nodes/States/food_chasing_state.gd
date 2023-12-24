extends State
class_name FoodChasingState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var food_detector: Area2D

@export var eating_distance = 8

var target

# Called when the node enters the scene tree for the first time.
func _ready():
	if not machine:
		machine = $'..'
	if not host:
		host = $"../.."
	if not animation_player:
		animation_player = host.get_node("AnimationPlayer")
	if not food_detector:
		food_detector = host.get_node("FoodDetector")
	
func process(delta):
	if not target or not is_instance_valid(target):
		var carrots = food_detector.get_overlapping_bodies()
		if not carrots:
			transition_state("waiting_state")
			return
		target = Globals.get_closest_node(host, carrots)
	host.move(target.global_position - host.global_position, delta)
	animation_player.play("walking")
	
	var distance = host.global_position.distance_to(target.global_position)
	if distance < eating_distance * host.scale.x:
		transition_state("eating_state", {"target" = target})
