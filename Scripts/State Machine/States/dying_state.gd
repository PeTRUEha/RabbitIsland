extends State
class_name DyingState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

@export var dying_time = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	if not machine:
		machine = $'..'
	if not host:
		host = $"../.."
	if not animation_player:
		animation_player = host.get_node("AnimationPlayer")
	if not sprite:
		sprite = host.get_node("Sprite2D")
		
func enter(args: Dictionary = {}):
	animation_player.play("dying")
	create_tween().tween_property(sprite, "modulate", Color.TRANSPARENT, 3)
	create_tween().tween_callback(host.queue_free).set_delay(3)
	
func exit():
	push_error("Cannot exit dying state")
