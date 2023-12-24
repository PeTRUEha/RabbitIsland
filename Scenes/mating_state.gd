extends State
class_name MatingState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var food_detector: Area2D

@export var distance_to_enter =35
var target: RabbitHole
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

func enter(args: Dictionary = {}):
	var rabbit_holes = get_tree().get_nodes_in_group("rabbit_holes")
	# как сделать массив массивом более узкого типа?
	if args:
		target = args['hole']
	else:
		target = Globals.get_closest_node(host, rabbit_holes)
	host.emit_signal("ready_to_mate", host, target)
	
	
func process(delta):
	var vector_to_target = target.position - host.position
	if vector_to_target.length() < distance_to_enter:
		transition_state("waiting_state")
		target.let_in(host)
	
	host.move(vector_to_target, delta)
	animation_player.play("walking")
	
func exit():
	host.emit_signal("no_longer_mating", host, target)
