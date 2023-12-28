extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_time(time_left):
	var minutes = int(time_left / 60)
	var seconds = time_left % 60
	text = str(minutes, ":", seconds)
