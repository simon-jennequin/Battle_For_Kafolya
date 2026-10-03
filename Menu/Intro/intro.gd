extends SCENE


func _ready():
	$VideoStreamPlayer.play()
	# Optionnel : Passer si le joueur appuie sur une touche
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
		skip_intro()
	if not $VideoStreamPlayer.is_playing():
		skip_intro()

func skip_intro():
	SceneManager.push_scene("res://Menu/Selection/selection.tscn")  # Change la scène
