extends Node
class_name State

signal state_transitioned(new_state: String, args: Dictionary)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func enter(args: Dictionary = {}):
	pass
	
func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	pass
	
func transition_state(new_state: String, args: Dictionary = {}):
	state_transitioned.emit(new_state, args)
