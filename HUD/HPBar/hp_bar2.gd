extends Node2D


@onready var damage_bar: ProgressBar = $damage_bar
@onready var hp_bar: ProgressBar = $damage_bar/hp_bar


@export var own:CharacterBody2D
var appeared = false
var disapeared = true

@onready var timer: Timer = $damage_bar/Timer


var hp_before 
var can_disapear = true
var ratioo :=1.0
var camera
var width:float


func _ready() -> void:
	hp_bar.modulate.a = 0
	damage_bar.modulate.a = 0
	own.damaged.connect(func():appear();damage_bar.value=hp_before;hp_before=own.hp)
	hp_bar.max_value = own.max_hp
	hp_bar.value = own.max_hp
	damage_bar.value = own.max_hp
	damage_bar.max_value = own.max_hp
	hp_before = own.max_hp
	var stylebox_fill = hp_bar.get_theme_stylebox("fill").duplicate()
	hp_bar.add_theme_stylebox_override("fill", stylebox_fill)
	var stylebox_fill2 = damage_bar.get_theme_stylebox("fill").duplicate()
	damage_bar.add_theme_stylebox_override("fill", stylebox_fill2)
	var shadow = damage_bar.get_theme_stylebox("background").duplicate()
	if not SceneManager.current.teamplay:
		match own.couleur:
			"red":shadow.shadow_color = Color(1,0,0,0.5)
			"blue":shadow.shadow_color = Color(0,0,0,1.5)
			"yellow":shadow.shadow_color = Color(1,1,0,0.5)
			"green":shadow.shadow_color = Color(0,1,0,0.5)
	else:
		match own.team:
			1:shadow.shadow_color = Color(0,0,0,1.5)
			2:shadow.shadow_color = Color(1,0,0,0.5)
	damage_bar.add_theme_stylebox_override("background", shadow)
	width = hp_bar.size.x
	camera = SceneManager.get_camera()
func appear():
	disapeared= false
	appeared = true
	timer.stop()
	

func disapear():
	disapeared= true
	appeared = false
	timer.stop()


	
	
# Called when the node enters the scene tree for the first time.

	
func _process(delta: float) -> void:
	ratioo = own.hp/own.max_hp
	var stylebox = hp_bar.get_theme_stylebox("fill")
	
	if ratioo>0.5:
		ratioo = (own.hp-own.max_hp/2)/(own.max_hp/2)
		
		stylebox.bg_color = Color(1.0-ratioo, 1.0, 0.0)
		
	else:
		ratioo = own.hp/(own.max_hp/2)
		stylebox.bg_color = Color(1.0, ratioo, 0.0)
	hp_bar.add_theme_stylebox_override("fill", stylebox)
	if hp_bar.value<damage_bar.value:
		can_disapear = false
		damage_bar.value-=delta*10
	else:
		
		can_disapear = true
	hp_bar.value = own.hp
	if appeared and hp_bar.modulate.a<1:
		hp_bar.modulate.a+=delta*10
		damage_bar.modulate.a+=delta*10
		if hp_bar.modulate.a>1:
			hp_bar.modulate.a=1
			damage_bar.modulate.a=1
			
	elif appeared and hp_bar.modulate.a==1 and can_disapear:
		appeared = false
		timer.start()
	elif disapeared and hp_bar.modulate.a>0:
		
		hp_bar.modulate.a-=delta*10
		damage_bar.modulate.a-=delta*10
		if hp_bar.modulate.a<0:
			hp_bar.modulate.a=0
			damage_bar.modulate.a=0
	if camera==null or not camera.has_method("get_border_right"):return	
	if own.global_position.x+width/2>camera.get_border_right():
		global_position.x = camera.get_border_right()-width/2
	elif own.global_position.x-width/2<camera.get_border_left():
		global_position.x = camera.get_border_left()+width/2
	else:
		position.x = 0.0


func _on_timer_timeout() -> void:
	disapear()
	
