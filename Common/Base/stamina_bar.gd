extends ProgressBar
@onready var stamina_bar: ProgressBar = $"."

@export var own: ENTITY
func _ready() -> void:
	var stylebox = stamina_bar.get_theme_stylebox("fill").duplicate()
	
	match own.couleur:
		"red":
			stylebox.bg_color = Color(1, 0, 0)
		"green":
			stylebox.bg_color = Color(0, 1, 0)
		"yellow":
			stylebox.bg_color = Color(1, 1, 0)
		"blue":
			stylebox.bg_color = Color(0, 0, 1)
	
	stamina_bar.add_theme_stylebox_override("fill", stylebox)
	
	
	
func _process(delta: float) -> void:
	value = own.stamina
	
