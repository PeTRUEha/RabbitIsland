extends State
class_name ThinkingState

@onready var host: Rabbit = $"../.."
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var food_detector: Area2D

@export var food_theshold = 100

@onready var predator_detector: Area2D = host.get_node("PredatorDetector")

# Called when the node enters the scene tree for the first time.
func _ready():
	if not machine:
		machine = $'..'
	if not animation_player:
		animation_player = host.get_node("AnimationPlayer")
	if not food_detector:
		food_detector = host.get_node("FoodDetector")

func enter(args: Dictionary = {}):
	if host.fullness > food_theshold:
		transition_state("mating_state")
	elif food_detector.get_overlapping_bodies():
		transition_state("food_chasing_state")
	else:
		transition_state("wandering_state")
