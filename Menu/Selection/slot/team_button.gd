extends TextureRect
@onready var state: Label = $state




func cursor_interact(id):
	SceneManager.current.swap_mode()
	
func change():
	
	if SceneManager.current.teamplay:
		state.text = "ON"
	else:state.text = "OFF"	
