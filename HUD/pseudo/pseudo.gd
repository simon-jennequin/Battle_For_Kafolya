extends CenterContainer
@export var own:ENTITY

@onready var label: Label =  $PanelContainer/Pseudo

@onready var panel: PanelContainer = $PanelContainer


const LUCKIEST_GUY_REGULAR = preload("res://HUD/pseudo/LuckiestGuy-Regular.ttf")
var camera
var width 
var padding :=10
var is_ready = false
func _ready() -> void:
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 25
	label.label_settings.font = LUCKIEST_GUY_REGULAR
	if not SceneManager.current.teamplay:
		match own.couleur:
			"red":
				label.label_settings.font_color = Color(1, 0, 0)
			"green":
				label.label_settings.font_color = Color(0, 1, 0)
			"yellow":
				label.label_settings.font_color = Color(1, 1, 0)
			"blue":
				label.label_settings.font_color = Color(0, 0, 1)
	else:
		match own.team:
			1:label.label_settings.font_color = Color(0, 0, 1)
			2:label.label_settings.font_color = Color(1, 0, 0)
	if own.player!=null:
		label.text = own.player.pseudo
	camera = SceneManager.get_camera()
	width = label.size.x
	visible=false

func _process(delta: float) -> void:
	
	if own.is_controlled:
		panel.visible=true
		label.visible = true
	else:
		panel.visible=false
		label.visible = false
	
	if not camera.has_method("get_border_right"):return	
	visible = true
	if own.global_position.x+width/2>camera.get_border_right():
		
		global_position.x = camera.get_border_right()-width/2
	elif own.global_position.x-width/2<camera.get_border_left():
		
		global_position.x = camera.get_border_left()+width/2
	else:
		position.x = 0.0
