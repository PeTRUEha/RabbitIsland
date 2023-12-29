extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true

func _shortcut_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("Attack"):
		var tree = get_tree()
		tree.paused = false
		visible = not visible
		queue_free()
	#Viewport.set_input_as_handled()
