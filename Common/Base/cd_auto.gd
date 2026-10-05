extends ProgressBar

@export var cd_bar:ProgressBar
@export var cooldown:float
@export var own:ENTITY
var elapsed := 0.0
func _ready() -> void:
	elapsed = cooldown
	cd_bar.max_value = cooldown
	cd_bar.z_index = 10
	var stylebox = cd_bar.get_theme_stylebox("fill").duplicate()
	
	match own.couleur:
		"red":
			stylebox.bg_color = Color(1, 0, 0)
		"green":
			stylebox.bg_color = Color(0, 1, 0)
		"yellow":
			stylebox.bg_color = Color(1, 1, 0)
		"blue":
			stylebox.bg_color = Color(0, 0, 1)
	
	cd_bar.add_theme_stylebox_override("fill", stylebox)
func is_ready():
	if elapsed>=cooldown:
		return true
	return false
	
func _process(delta: float) -> void:
	elapsed += delta
	if not is_ready():
		
		cd_bar.visible=true
		cd_bar.value = cooldown-elapsed
	else:
		cd_bar.visible = false

func launch():
	elapsed = 0.0
