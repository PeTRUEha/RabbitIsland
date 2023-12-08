extends State
class_name EatingState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var food_detector: Area2D

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
	create_tween().tween_callback(finish_eating.bind(target)).set_delay(host.eating_time)
	
func finish_eating(carrot: Carrot):
	target.remove_eater()
	target.decrease_food(host.eating_size)
	host.fullness += host.eating_size
	state_transitioned.emit('food_searching_state')
	
func process(delta):
	animation_player.play("eating")
