extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func game_over(score: int, additional_info: String = "", time_left = ""):
	visible = true
	$MenuPanel/MenuContainer/ScoreContainer/ScorePanel/Score.text = str(score)
	$MenuPanel/MenuContainer/TimeLeftPanel/TimeLeft.text += Globals.format_time(time_left)
	if additional_info:
		$MenuPanel/MenuContainer/AdditionalInfo.text = additional_info


func _on_level_game_over(score: int, additinal_info: String, time_left: int):
	game_over(score, additinal_info, time_left)
	$"../Level/UI".visible = false
