extends Control

var DisplayMargin: int = 15;
var ControlsLabel: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var ControlsLabel = $ControlsLabel
	ControlsLabel.position.x = DisplayMargin
	ControlsLabel.position.y = get_viewport_rect().size.y - ControlsLabel.size.y - DisplayMargin


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ControlsLabel = $ControlsLabel
	ControlsLabel.position.x = DisplayMargin
	ControlsLabel.position.y = get_viewport_rect().size.y - ControlsLabel.size.y - DisplayMargin
