extends Node
class_name StateMachine

@export var initial_state: State
var current_state = initial_state
var states: Dictionary = {}
# Called when the node enters the scene tree for the first time.
func _ready():
	for child in self.get_children():
		if child is State:
			states[child.name.to_snake_case()] = child
			child.state_transitioned.connect(transition_state)
	
	if not initial_state:
		initial_state = states.values()[0]
	current_state=initial_state
	initial_state.activate()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	current_state.process(delta)
	
func _physics_process(delta):
	current_state.physics_process(delta)

func transition_state(new_state_name: String, args: Dictionary = {}):
	current_state.deactivate()
	#print(current_state, " -> ", new_state_name)
	current_state = states[new_state_name.to_snake_case()]
	current_state.activate(args)
	
