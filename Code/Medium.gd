extends Button

@export
var GameScene: PackedScene

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Difficulty set to Medium")
			get_tree().change_scene_to_packed(GameScene)
