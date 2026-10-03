extends Control
class_name CADRE_HUD
@onready var cadre: Node2D = $Node2D/cadre
@onready var hp_1: ProgressBar = $Node2D/hp1
@onready var hp_2: ProgressBar = $Node2D/hp2
@onready var label: Label = $Node2D/CenterContainer/PanelContainer/Label
@onready var pt_1: Sprite2D = $Node2D/pt1
@onready var pt_2: Sprite2D = $Node2D/pt2
@onready var pt_3: Sprite2D = $Node2D/pt3
@onready var pt: Sprite2D = $Node2D/pt

@onready var score: Label = $Node2D/score/score
@export var positions_cd:Array

@onready var all_cd = [$Node2D/CD_SPELL,$Node2D/CD_SPELL2,$Node2D/CD_SPELL3,$Node2D/CD_SPELL4]
@onready var cd_switch = $cd_switch

@onready var bg: Panel = $Node2D/bg
@onready var label_pv_1: Label = $Node2D/PV1/label_pv1

@onready var label_pv_2: Label = $Node2D/PV2/label_pv2

const CADREE = preload("res://HUD/cadre/cadre_hud.tscn")
var player
var id

static func create(container,id):
	var inst = CADREE.instantiate()
	inst.id = id
	container.add_child(inst)
	inst.label.text = id.pseudo
	var stylebox = inst.bg.get_theme_stylebox("panel").duplicate()
	var cadre_style = inst.cadre.get_node("cadre")
	var transparence = 0.3
	if not SceneManager.current.teamplay:
		match id.color:
			"red":stylebox.bg_color = Color(1,0,0,transparence);cadre_style.modulate = Color(1,0,0)
			"blue":stylebox.bg_color = Color(0,0,1,transparence);cadre_style.modulate = Color(0,0,1)
			"green":stylebox.bg_color = Color(0,1,0,transparence);cadre_style.modulate = Color(0,1,0)
			"yellow":stylebox.bg_color = Color(1,1,0,transparence);cadre_style.modulate = Color(1,1,0)
	else:
		match id.team:
			1:stylebox.bg_color = Color(0,0,1,transparence);cadre_style.modulate = Color(0,0,1)
			2:stylebox.bg_color = Color(0,0,1,transparence);cadre_style.modulate = Color(1,0,0)
	inst.bg.add_theme_stylebox_override("panel",stylebox)
	return inst
func assignate(new_id):
	visible = true
	id = new_id
	label.text = id.pseudo
	var stylebox = bg.get_theme_stylebox("panel").duplicate()
	var cadre_style = cadre.get_node("cadre")
	var transparence = 0.3
	if not SceneManager.current.teamplay:
		match id.color:
			"red":stylebox.bg_color = Color(1,0,0,transparence);cadre_style.modulate = Color(1,0,0)
			"blue":stylebox.bg_color = Color(0,0,1,transparence);cadre_style.modulate = Color(0,0,1)
			"green":stylebox.bg_color = Color(0,1,0,transparence);cadre_style.modulate = Color(0,1,0)
			"yellow":stylebox.bg_color = Color(1,1,0,transparence);cadre_style.modulate = Color(1,1,0)
	else:
		match id.team:
			1:stylebox.bg_color = Color(0,0,1,transparence);cadre_style.modulate = Color(0,0,1)
			2:stylebox.bg_color = Color(0,0,1,transparence);cadre_style.modulate = Color(1,0,0)
	bg.add_theme_stylebox_override("panel",stylebox)
	return self

func setup(new_player):
	player = new_player
	player.cadre_hud = self
	player.switched.connect(func():change_perso())
	player.perso.damaged.connect(func():damage())
	player.perso2.damaged.connect(func():damage())
	player.switched.connect(func():switch())
	change_perso()
	pt_1.visible= false
	pt_2.visible= false
	pt_3.visible= false
	pt.visible = false
	score.visible=false
	if id.score==1:
		pt_1.visible=true
	elif id.score==2:
		pt_1.visible= true
		pt_2.visible= true
	elif id.score==3:
		pt_1.visible= true
		pt_2.visible= true
		pt_3.visible= true
	elif id.score>3:
		score.visible=true
		score.text = str(id.score)
		pt.visible = true
	all_cd[0].assignate(id.color,player.SPELL1_CHANGED,player.perso,1,player.perso.SPELL1,player.perso.SPELL1,true)
	all_cd[1].assignate(id.color,player.SPELL2_CHANGED,player.perso,2,player.perso.SPELL2,player.perso.SPELL2,true)
	all_cd[2].assignate(id.color,player.SPELL3_CHANGED,player.perso2,1,player.perso2.SPELL1,player.perso2.SPELL1,false)
	all_cd[3].assignate(id.color,player.SPELL4_CHANGED,player.perso2,2,player.perso2.SPELL2,player.perso2.SPELL2,false)
	cd_switch.assignate(player.SWITCH_CHANGED,player.cd_switch)
	hp_1.value = 1
	hp_1.max_value = 1
	hp_2.value = 1
	hp_2.max_value = 1
	var stylebox = hp_1.get_theme_stylebox("fill")
	stylebox.bg_color = Color(0,1,0)
	hp_1.add_theme_stylebox_override("fill",stylebox)
	hp_2.add_theme_stylebox_override("fill",stylebox)
	label_pv_1.text = str(player.perso.max_hp)
	label_pv_2.text = str(player.perso2.max_hp)
	
func damage():
	hp_1.max_value = player.perso.max_hp
	hp_1.value = player.perso.hp
	label_pv_1.text = str(player.perso.hp)
	var ratioo = player.perso.hp/player.perso.max_hp
	var stylebox = hp_1.get_theme_stylebox("fill").duplicate()
	if ratioo>0.5:
		ratioo = (player.perso.hp-player.perso.max_hp/2)/(player.perso.max_hp/2)
		
		stylebox.bg_color = Color(1.0-ratioo, 1.0, 0.0)
		
	else:
		ratioo = player.perso.hp/(player.perso.max_hp/2)
		stylebox.bg_color = Color(1.0, ratioo, 0.0)
	hp_1.add_theme_stylebox_override("fill", stylebox)
	
func switch():
	hp_1.max_value = player.perso.max_hp
	hp_1.value = player.perso.hp
	hp_2.max_value = player.perso2.max_hp
	hp_2.value = player.perso2.hp
	var ratioo = player.perso.hp/player.perso.max_hp
	var stylebox = hp_1.get_theme_stylebox("fill").duplicate()
	if ratioo>0.5:
		ratioo = (player.perso.hp-player.perso.max_hp/2)/(player.perso.max_hp/2)
		
		stylebox.bg_color = Color(1.0-ratioo, 1.0, 0.0)
		
	else:
		ratioo = player.perso.hp/(player.perso.max_hp/2)
		stylebox.bg_color = Color(1.0, ratioo, 0.0)
	hp_1.add_theme_stylebox_override("fill", stylebox)
	ratioo = player.perso.hp/player.perso.max_hp
	stylebox = hp_2.get_theme_stylebox("fill").duplicate()
	if ratioo>0.5:
		ratioo = (player.perso2.hp-player.perso2.max_hp/2)/(player.perso2.max_hp/2)
		
		stylebox.bg_color = Color(1.0-ratioo, 1.0, 0.0)
		
	else:
		ratioo = player.perso2.hp/(player.perso2.max_hp/2)
		stylebox.bg_color = Color(1.0, ratioo, 0.0)
	hp_2.add_theme_stylebox_override("fill", stylebox)
	label_pv_1.text = str(player.perso.hp)
	label_pv_2.text = str(player.perso2.hp)
func change_perso():
	var character
	if player.perso is BREEZ:character = "breez"
	elif player.perso is CHOBUSHI:character = "chobushi"
	elif player.perso is PEACEGUIN:character = "peaceguin"
	cadre.get_node("animation").play(character)
	

	
	
		
		
