extends TextureRect
@onready var state: Label = $state
@onready var stream: AudioStreamPlayer2D = $AudioStreamPlayer2D





func cursor_interact(id):
	SceneManager.current.swap_friendly()
	stream.play()
func change():
	
	if SceneManager.current.friendlyfire:
		state.text = "ON"
	else:state.text = "OFF"	
