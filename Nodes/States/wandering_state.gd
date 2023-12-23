extends State
class_name WanderingState

var duration_range: Vector2 = Vector2(1.5, 2.5)
var direction: Vector2
var duration: float


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
	var boundary_evasion = host.get_boundary_evasion()
	var random_direction = Vector2.from_angle(randf_range(0, 2*PI))
	direction = (boundary_evasion + random_direction).normalized()
	duration = randf_range(duration_range.x, duration_range.y)
	create_tween().tween_callback(_wait).set_delay(duration)
	
func _wait():
	if active:
		transition_state("waiting_state")
	
func process(delta):
	host.move(direction, delta)
	animation_player.play("walking")
