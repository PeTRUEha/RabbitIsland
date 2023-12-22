extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	create_tween().tween_property(self, "region_rect:size:y", 0 , 5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(region_rect.size.y)
	#region.rect.h
	#region_rect.size.y -= 10 * delta
