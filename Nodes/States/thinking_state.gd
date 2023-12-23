extends State
class_name ThinkingState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var food_detector: Area2D

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
	if food_detector.get_overlapping_bodies():
		transition_state("food_chasing_state")
	else:
		transition_state("wandering_state")
