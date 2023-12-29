extends CanvasLayer


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_cancel"):
		var tree = get_tree()
		tree.paused = not tree.paused
		visible = not visible
		
func _on_contitue_pressed():
	visible = false
	get_tree().paused = false
