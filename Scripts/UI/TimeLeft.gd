extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_time(time_left):
	var minutes = int(time_left / 60)
	var seconds = str(time_left % 60)
	if len(seconds) == 1:
		seconds = '0' + seconds
	text = str(minutes, ":", seconds)
