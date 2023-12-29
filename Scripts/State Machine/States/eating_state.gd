extends State
class_name EatingState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var food_detector: Area2D
@onready var audio_stream_player_2d = $"../../EatingSound"

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
	
func enter(args: Dictionary = {}):
	target = args['target']
	target.be_eaten()
	audio_stream_player_2d.play_from_last_position()
	var tween = create_tween().tween_callback(finish_eating).set_delay(host.eating_time)
	
func finish_eating():
	audio_stream_player_2d.stop_on_current_position()
	if active and is_instance_valid(target):
		target.decrease_food(host.eating_size)
		host.fullness += host.eating_size
		transition_state("thinking_state")
	elif active and not is_instance_valid(target):
		transition_state("thinking_state")
	
func process(delta):
	animation_player.play("eating")
