extends TextureRect
class_name CURSOR_SELECTION
var own
var selection
const CURSOR_B = preload("res://HUD/Cursor/cursor_b.png")
const CURSOR_J = preload("res://HUD/Cursor/cursor_j.png")
const CURSOR_R = preload("res://HUD/Cursor/cursor_r.png")
const CURSOR_V = preload("res://HUD/Cursor/cursor_v.png")
@onready var sprite: CURSOR_SELECTION = $"."
@onready var label: Label = $CenterContainer/Label

static func create(id,new_selection):
	var inst = preload("res://Menu/Selection/cursor_menu.tscn").instantiate()
	inst.selection = new_selection
	new_selection.add_child(inst)
	
	inst.own = id
	inst.label.text = id.pseudo
	inst.change_color()
	id.COLOR_CHANGED.connect(func():inst.change_color())
	return inst

func change_color():
	if not selection.teamplay:
		match own.color:
			"red":sprite.texture = CURSOR_R
			"blue":sprite.texture = CURSOR_B
			"green":sprite.texture = CURSOR_V
			"yellow":sprite.texture = CURSOR_J
	else:
		if own.team==1:sprite.texture = CURSOR_B
		else: sprite.texture = CURSOR_R

func destroy():
	queue_free()
		
	
		



	

	
