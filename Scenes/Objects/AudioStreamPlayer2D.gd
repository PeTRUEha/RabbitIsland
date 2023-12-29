extends AudioStreamPlayer2D

@onready var last_position = get_playback_position()
# Called when the node enters the scene tree for the first time.
func play_from_last_position():
	play(last_position)

func stop_on_current_position():
	last_position = get_playback_position()
	stop()
