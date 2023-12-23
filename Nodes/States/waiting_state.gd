extends State
class_name WaitingState

@export var waiting_time_range: Vector2 = Vector2(1, 2)

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
	create_tween().tween_callback(_move_on).set_delay(randf_range(waiting_time_range.x, waiting_time_range.y))
	animation_player.play("idle")

func _move_on():
	if active:
		transition_state("thinking_state")
	
func process(delta):
	host.velocity = Vector2.ZERO
	host.move_and_slide()
