extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_rabbit_ready_to_mate(rabbit: Rabbit, rabbit_hole: RabbitHole):
	print("got signal ", rabbit, " ", rabbit_hole)
	var rabbits = get_children()
	rabbits.erase(rabbit)
	if not rabbits:
		return
	Globals.get_closest_node(rabbit_hole, rabbits)
	
