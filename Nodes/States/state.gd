extends Node
class_name State

signal state_transitioned(new_state: String, args: Dictionary)
var active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func activate(args: Dictionary = {}):
	active = true
	enter(args)
	
func enter(args: Dictionary = {}):
	pass
	
func deactivate(args: Dictionary = {}):
	active = false
	exit()
	
func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	pass
	
func transition_state(new_state: String, args: Dictionary = {}):
	state_transitioned.emit(new_state, args)
