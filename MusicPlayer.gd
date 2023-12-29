extends Node2D

var index = 0
@onready var music_players: Array = get_children()
# Called when the node enters the scene tree for the first time.
func _ready():
	for player: AudioStreamPlayer in music_players:
		player.connect("finished", play_next)
	play_next()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func play_next():
	music_players[index].play()
	index = (index + 1) % len(music_players)
