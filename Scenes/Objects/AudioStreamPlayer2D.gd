extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	playing = true
	create_tween().tween_callback(func(): stream_paused=true).set_delay(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		print("playing ", playing, "\nstream_paused ", stream_paused, "\n")
