extends State
class_name RunningAwayState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var predator_detector: Area2D
@export var boundary_detector: Area2D

@export var treat_max_distance = 100
var treat

# Called when the node enters the scene tree for the first time.
func _ready():
	if not machine:
		machine = $'..'
	if not host:
		host = $"../.."
	if not animation_player:
		animation_player = host.get_node("AnimationPlayer")
	if not predator_detector:
		predator_detector = host.get_node("PredatorDetector")
	if not boundary_detector:
		boundary_detector = host.get_node("BoundaryDetector")
	
func process(delta):
	if not is_instance_valid(treat):
		transition_state("waiting_state")
		return
		
	var treat_to_host_vector = host.global_position - treat.global_position
	var distance = treat_to_host_vector.length()
	
	if distance > treat_max_distance * host.scale.x:
		transition_state("waiting_state")
		return
		
	var boundary_evasion = host.get_boundary_evasion()
	var movement_direction = treat_to_host_vector + boundary_evasion
	host.move(movement_direction, delta)
	animation_player.play("walking")


func enter(args: Dictionary = {}):
	self.treat = args["treat"]
