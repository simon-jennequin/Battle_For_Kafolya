extends CanvasLayer


var own
var prec_index :=0
var button_index := 0
var prev_y :=0.0
@onready var all_buttons = [$back,$selection]
var is_pressed:=false
var pause_pressed:=true
@onready var label: Label = $CenterContainer/Label




func start(id):
	
	own = id
	button_index = 0
	all_buttons[button_index].grab_focus()
	label.text = id.pseudo
func update_selection(move):
	
	all_buttons[button_index].release_focus()
	
	button_index = (button_index+move)%len(all_buttons)
	all_buttons[button_index].grab_focus()
	
	
	
func button_pressed():
	all_buttons[button_index].emit_signal("pressed")
func _process(delta: float) -> void:
	
	var joy_y := Input.get_joy_axis(own.manette, JOY_AXIS_LEFT_Y)

	if joy_y > 0.5 and prev_y <= 0.5:
		update_selection(1)
	elif joy_y < -0.5 and prev_y >= -0.5:
		update_selection(-1)
	prev_y = joy_y

	if Input.is_joy_button_pressed(own.manette, JOY_BUTTON_A) and not is_pressed:
		button_pressed()
		is_pressed = true
	elif not Input.is_joy_button_pressed(own.manette, JOY_BUTTON_A):
		is_pressed = false

	if Input.is_joy_button_pressed(own.manette, JOY_BUTTON_START) and not pause_pressed:
		pause_pressed = true
		SceneManager.toggle_pause(own)
	elif not Input.is_joy_button_pressed(own.manette, JOY_BUTTON_START):
		pause_pressed = false


func _on_back_pressed() -> void:
	SceneManager.toggle_pause(own)
	pass # Replace with function body.


func _on_selection_pressed() -> void:
	SceneManager.toggle_pause(own)
	SceneManager.pop_scene()
