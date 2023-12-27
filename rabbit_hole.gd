extends StaticBody2D
class_name RabbitHole

@export var birth_cost = 40
@export var mating_length = 5
@export var displacement_amplitude = 0.3
@onready var base_sprite_position = $Sprite2D.position

var residents: Array[Rabbit] = []
var mating: bool = false
var digable: bool = true
var digable_timeout = 20
@onready var rabbit_controller = $"/root/Level/RabbitController"
# Called when the node enters the scene tree for the first time.
var rabbit_resource = load("res://Scenes/rabbit.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mating:
		var horisontal_displacement = scale.x * displacement_amplitude * cos(3.14 * Time.get_ticks_msec() / 50)
		var veritical_displacement = scale.y * displacement_amplitude * sin(2.7 * Time.get_ticks_msec() / 50)
		$Sprite2D.position = base_sprite_position + Vector2(horisontal_displacement, veritical_displacement)

func be_digged():
	print("digging", digable, " ", len(residents) > 0)
	if residents:
		kick_out_one()
	else:
		digable = false
		create_tween().tween_property(self, "digable", true, digable_timeout)

func let_in(rabbit: Rabbit):
	residents.append(rabbit)
	rabbit_controller.remove_child(rabbit)
	_try_start_mating()
	digable = true

func kick_out_one():
	var rabbit = residents[-1]
	residents.erase(rabbit)
	var spawning_radius = $CollisionShape2D.shape.height + rabbit.get_node("CollisionShape2D").shape.height
	rabbit.position = Vector2(position.x, position.y) + spawning_radius * Vector2.from_angle(randf_range(0, 2*PI))
	rabbit_controller.add_child(rabbit)
	rabbit.cancel_mating()
	if len(residents) < 2:
		_end_mating()
	

func _try_start_mating():
	if mating:
		return
	elif _ready_to_mate():
		mating = true
		_start_mating()
	else:
		mating = false

func _ready_to_mate():
	print(len(residents), " ", _get_fullest_resident().fullness)
	if len(residents) >= 2 and _get_fullest_resident().fullness >= birth_cost:
		return true
	else:
		return false
		
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
	mating = false
	_create_new_rabbit()
	_try_start_mating()
	if not mating:
		while residents:
			kick_out_one()
	
func _create_new_rabbit():
	var rabbit: Rabbit = rabbit_resource.instantiate()
	residents.append(rabbit)
	print(rabbit)
	pass

