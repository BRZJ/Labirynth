extends Button

@onready var GameScene := "res://Game/game.tscn"

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("Difficulty set to Easy")

