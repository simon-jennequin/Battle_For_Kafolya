extends Button
class_name PSEUDO_BUTTON
const PSEUDO = preload("res://Menu/Selection/pseudo_button.tscn")
@onready var button: PSEUDO_BUTTON = $"."
@onready var label: Label = $CenterContainer/Label
@onready var audio: AudioStreamPlayer2D = $audio


var pseudo := ""
var current_color:="white"
var selection
static func create(cadre):
	var inst = PSEUDO.instantiate()
	inst.selection = cadre.own.selection
	
	return inst


func change(new_pseudo,color):
	pseudo = new_pseudo
	label.text = new_pseudo
	
	
	change_color(color)
func change_color(color):
	if current_color==color:return
	var stylebox = self.get_theme_stylebox("normal").duplicate()
	
	match color:
			"red":stylebox.bg_color = Color(1,0,0)
			"blue":stylebox.bg_color = Color(0,0,1)
			"green":stylebox.bg_color = Color(0,1,0)
			"yellow":stylebox.bg_color = Color(1,1,0)
	
		
	self.add_theme_stylebox_override("normal",stylebox)
func cursor_interact(id):
	id.change_pseudo(pseudo)
	id.press_x()
	audio.play()
