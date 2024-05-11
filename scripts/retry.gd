extends Button

func _on_button_pressed():
	print("pressed")
	var _reload = get_tree().reload_current_scene()
