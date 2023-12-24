extends State
class_name ThinkingState

@onready var host: Rabbit = $"../.."
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var food_detector: Area2D

@export var food_theshold = 100

@onready var predator_detector: Area2D = host.get_node("PredatorDetector")
@onready var rabbit_controller: RabbitController = host.get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	if not machine:
		machine = $'..'
	if not animation_player:
		animation_player = host.get_node("AnimationPlayer")
	if not food_detector:
		food_detector = host.get_node("FoodDetector")

func enter(args: Dictionary = {}):
	## calling make_desision next frame
	create_tween().tween_callback(make_desision).set_delay(0)
	
func make_desision():
	if not active:
		return
	if rabbit_controller.mates_required:
		transition_state("mating_state", {"hole": rabbit_controller.mates_required[0]})
	if host.fullness > food_theshold:
		transition_state("mating_state")
	elif food_detector.get_overlapping_bodies():
		transition_state("food_chasing_state")
	else:
		transition_state("wandering_state")
