extends Node2D

@onready var player: Fox = get_tree().get_nodes_in_group("player")[0]
var score = 0
var time_left = 60 * 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$UI/TimeLeft.update_time(time_left)
	$UI/RabbitCounter.update_rabbits(score)

func _on_fox_rabbit_killed():
	score += 1
	$UI/RabbitCounter.update_rabbits(score)



func _on_timer_timeout():
	time_left -= 1
	$UI/TimeLeft.update_time(time_left)
	
