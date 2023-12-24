extends StaticBody2D
class_name RabbitHole

@export var birth_cost = 40
@export var mating_length = 5
@export var rabbit_resource = preload("res://Scenes/rabbit.tscn")

var residents: Array[Rabbit] = []
var mating: bool = false
@onready var rabbit_controller = $"/root/Level/RabbitController"
# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func let_in(rabbit: Rabbit):
	residents.append(rabbit)
	rabbit_controller.remove_child(rabbit)
	_try_start_mating()

func kick_out_one():
	var rabbit = residents[-1]
	residents.erase(rabbit)
	rabbit_controller.add_child(rabbit)

func _try_start_mating():
	if mating:
		return
	elif _ready_to_mate():
		mating = true
		_start_mating()
	else:
		mating = false

func _ready_to_mate():
	if len(residents) < 2 or _get_fullest_resident().fullness < birth_cost:
		return false
	else:
		return true
		
func _get_fullest_resident() -> Rabbit:
	var fullest_resident = residents[0]
	for resident in residents:
		if resident.fullness > fullest_resident.fullness:
			fullest_resident = resident
	return fullest_resident
	
func _start_mating():
	var fullest_resident = _get_fullest_resident()
	fullest_resident.fullness -= birth_cost
	create_tween().tween_callback(_end_mating).set_delay(mating_length)
	
func _end_mating():
	if not mating:
		return
	_create_new_rabbit()
	_try_start_mating()
	
func _create_new_rabbit():
	var rabbit = rabbit_resource.instantiate()
	rabbit.position = Vector2(position.x, position.y)
	residents.append(rabbit)

