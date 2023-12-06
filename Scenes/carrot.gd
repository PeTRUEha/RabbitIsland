extends StaticBody2D
class_name Carrot
var base_sprite_position = null
var food = 30
@export var eaters = 0
@export var one_bite_time = 0.5

@export var displacement_amplitude = 0.3

func _ready():
	base_sprite_position = $Sprite2D.position

func be_eaten():
	eaters += 1

func remove_eater():
	eaters -= 1
		
func decrease_food(food_decrease):
	food -= food_decrease
	if food <= 0:
		queue_free()
	
func _process(delta):
	if eaters > 0:
		var horisontal_displacement = scale.x * eaters * displacement_amplitude * cos(3.14 * Time.get_ticks_msec() / 50)
		var veritical_displacement = scale.y * eaters * displacement_amplitude * sin(2.7 * Time.get_ticks_msec() / 50)
		$Sprite2D.position = base_sprite_position + Vector2(horisontal_displacement, veritical_displacement)
