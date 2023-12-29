extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_time(time_left):
	text = Globals.format_time(time_left)
