extends State
class_name RunningAwayState

@export var host: PhysicsBody2D
@export var machine: StateMachine
@export var animation_player: AnimationPlayer
@export var predator_detector: Area2D
@export var boundary_detector: Area2D

@export var treat_max_distance = 100
@export var boundary_evasion_coefficient = 10
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
		transition_state("food_searching_state")
		return
		
	var treat_to_host_vector = host.global_position - treat.global_position
	var distance = treat_to_host_vector.length()
	
	if distance > treat_max_distance * host.scale.x:
		transition_state("food_searching_state")
		return
		
	var boundary_detected = boundary_detector.get_overlapping_bodies()
	var boundary_evasion = Vector2()
	if boundary_detected:
		var tile_map: TileMap = boundary_detected[0]
		for rid in host.boundary_shapes_rid:
			var coords = tile_map.to_global(tile_map.map_to_local(tile_map.get_coords_for_body_rid(rid)))
			var boundary_to_host_vector = host.global_position - coords
			var boundary_distance = boundary_to_host_vector.length()
			var coefficient = 1 / (distance + 20) * boundary_evasion_coefficient
			boundary_evasion += coefficient * boundary_to_host_vector.normalized()
	else:
		boundary_evasion = Vector2()

	var movement_direction = treat_to_host_vector.normalized() + boundary_evasion
	host.move(movement_direction, delta)
	animation_player.play("walking")


func enter(args: Dictionary = {}):
	self.treat = args["treat"]
