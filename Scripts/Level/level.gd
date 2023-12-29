extends Node2D

@onready var player: Fox = get_tree().get_nodes_in_group("player")[0]
var score = 0
var time_left = 60 * 3

signal game_over(score: int, additinal_info: String, time_left: int)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$UI/Panel2/TimeLeft.update_time(time_left)
	$UI/Panel/RabbitCounter.update_rabbits(score)

func _on_fox_rabbit_killed():
	score += 1
	$UI/Panel/RabbitCounter.update_rabbits(score)
		

func _on_timer_timeout():
	time_left -= 1
	$UI/Panel2/TimeLeft.update_time(time_left)
	
	if time_left < 0:
		game_over.emit(score, "", time_left)
		get_tree().paused = true
	
	var rabbits_left = len(get_tree().get_nodes_in_group("rabbit")) + $HoleController.get_hidden_rabbit_conut()
	if not rabbits_left:
		var text = "All rabbits have periched. You now succumb to the evil carrot powers."
		if score < 20:
			text += "\nYou can do better."
		game_over.emit(score, text, time_left)
		get_tree().paused = true
		$CarrotController/Timer.wait_time = 0.01
		$CarrotController.process_mode = PROCESS_MODE_WHEN_PAUSED

func _on_fox_can_dig():
	$UI/FoxCanDig.visible = true

func _on_fox_cant_dig():
	$UI/FoxCanDig.visible = false
