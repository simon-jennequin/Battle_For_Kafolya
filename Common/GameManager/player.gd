extends Node
class_name PlayerController


var id_manette := -1
var team
var choix := 0

var perso = null
var perso2
var persos = []
var spawn_pos := Vector2.ZERO
var viseur = Sprite2D.new()
var a_was_pressed = false
var pseudo :="Player"
var auto_pressed = false
var spell1_pressed = false
var spell2_pressed = false
var switch_pressed = false
var is_switch = false
var is_dead = false
var cadre_hud
var s0=0
var max_switch = 0
var aimX
var aimY
var is_aim = false
var pause_pressed:=false
var game
var color :="white"
var d0 = 0
var death_switch = false
const SWAP1 = preload("res://Entities/sound/swap1.wav")
const SWAP2 = preload("res://Entities/sound/swap2.wav")
var can_play = false
const CURSOR = preload("res://HUD/Cursor/cursor.tscn")
var new_cursor
var id
var switch_time:float=0.0
var cd_switch := 6.0
const PAUSE_MENU = preload("res://Menu/pause/pause_menu.tscn")

signal SPELL1_CHANGED
signal SPELL2_CHANGED
signal SPELL3_CHANGED
signal SPELL4_CHANGED
signal SWITCH_CHANGED
signal switched

func init(new_id,controller, new_persos_chose: Array,new_color,new_team,new_pseudo,pos,new_game):
	id = new_id
	id_manette = controller	
	game = new_game
	pseudo = new_pseudo
	color = new_color
	team = new_team
	
	for id_perso in new_persos_chose:
		var instance = SceneManager.all_char[id_perso].instantiate()
		var layer
		if not new_game.teamplay or new_game.friendlyfire:
			layer = id.id
		else:
			layer = team
		
		instance.init(layer,game,color,self,new_team)
		persos.append(instance)
	
	perso = persos[choix]
	perso2 = persos[(choix+1)%2]
	perso.is_controlled=true
	perso.global_position = pos
	self.add_child(perso)
	perso.parent = self
	perso2.parent = self
	print("perso 1 et 2",team)
	
	
	
	

func set_active_perso(index: int):
	for i in range(persos.size()):
		persos[i].is_controlled = (i == index)
	perso = persos[index]
func _physics_process(delta: float) -> void:
	
	if death_switch and d0>0:
		
		d0-=delta*1000
		
	elif death_switch and d0<=0:
		
		death_switch=false
		spawn_character(persos[(choix+1)%2],perso.global_position)
		switch_character()

		perso.apply_status(INVINCIBLE.create(),3000,"invincible")
		
		
func controller_input():
	var manettes = Input.get_connected_joypads()
	if not manettes.has(id_manette):
		return
	
	# Debug : afficher toutes les manettes connectées
	

	# Lecture des entrées (seulement si la manette est valide)
	var axisX = Input.get_joy_axis(id_manette, JOY_AXIS_LEFT_X)
	var axisY = Input.get_joy_axis(id_manette, JOY_AXIS_LEFT_Y)
	var axisX2 = Input.get_joy_axis(id_manette, JOY_AXIS_RIGHT_X)
	var axisY2 = Input.get_joy_axis(id_manette, JOY_AXIS_RIGHT_Y)
	
	
		
	if Input.is_joy_button_pressed(id_manette, JOY_BUTTON_Y):
		get_parent().start_round()
		
	if abs(axisX2)>0.2 or abs(axisY2)>0.2:
		aimX= Input.get_joy_axis(id_manette, JOY_AXIS_RIGHT_X)
		aimY = Input.get_joy_axis(id_manette, JOY_AXIS_RIGHT_Y)
		is_aim= true
		
	elif abs(axisX)>0.2 or abs(axisY)>0.2:
		aimX= Input.get_joy_axis(id_manette, JOY_AXIS_LEFT_X)
		aimY = Input.get_joy_axis(id_manette, JOY_AXIS_LEFT_Y)
		is_aim = true
		
	else:
		aimX= 0
		aimY = 0
		is_aim = false

	if abs(axisX) > 0.3:
		perso.move(axisX)
	if Input.get_joy_axis(id_manette, JOY_AXIS_LEFT_Y)>0.2:
		perso.down()
	#ouioui
	
	if Input.is_joy_button_pressed(id_manette, JOY_BUTTON_A):
		perso.jump(a_was_pressed,true)
		a_was_pressed = true
	else:
		perso.jump(a_was_pressed,false)
		a_was_pressed = false
		

	if Input.is_joy_button_pressed(id_manette, JOY_BUTTON_LEFT_SHOULDER):
		
		perso.spell1(spell1_pressed,true)
		spell1_pressed = true
	else:
		perso.spell1(spell1_pressed,false)
		spell1_pressed = false

	if Input.is_joy_button_pressed(id_manette, JOY_BUTTON_RIGHT_SHOULDER):
		
		perso.spell2(spell2_pressed,true)
		spell2_pressed = true
		
	else:
		perso.spell2(spell2_pressed,false)
		spell2_pressed = false

	if Input.get_joy_axis(id_manette, JOY_AXIS_TRIGGER_RIGHT) > 0.2:
		
		perso.auto(auto_pressed,true)
		auto_pressed = true
	else:
		perso.auto(auto_pressed,false)
		auto_pressed = false
	

	if Input.get_joy_axis(id_manette, JOY_AXIS_TRIGGER_LEFT)>0.2:
		
		switch(switch_pressed,true)
		switch_pressed = true
	else:
		switch(switch_pressed,false)
		switch_pressed = false
	if Input.is_joy_button_pressed(id_manette,JOY_BUTTON_START) and not pause_pressed:
		pause_pressed = true
		a_was_pressed = true
		
		SceneManager.toggle_pause(id)
	elif not Input.is_joy_button_pressed(id_manette,JOY_BUTTON_START):
		pause_pressed = false
	perso.aim(aimX,aimY,is_aim)


func calculate_cd(_delta):	
	if perso!=null and perso.AUTO >0:
		perso.AUTO-=_delta
	if perso!=null and perso.SPELL1 >0 and not perso.SPELL1_USED:perso.SPELL1-=_delta
	if perso!=null and perso.SPELL2 >0 and not perso.SPELL2_USED:perso.SPELL2-=_delta
	if perso2!=null and perso2.AUTO >0:
		perso2.AUTO-=_delta
	if perso2!=null and perso2.SPELL1 >0 and not perso2.SPELL1_USED:perso2.SPELL1-=_delta
	if perso2!=null and perso2.SPELL2 >0 and not perso2.SPELL2_USED:perso2.SPELL2-=_delta
	if switch_time>0:switch_time-=_delta
	emit_signal("SWITCH_CHANGED",switch_time)
	emit_signal("SPELL1_CHANGED",perso,1,perso.SPELL1,perso.CD_SPELL1,true)
	emit_signal("SPELL2_CHANGED",perso,2,perso.SPELL2,perso.CD_SPELL2,true)
	emit_signal("SPELL3_CHANGED",perso2,1,perso2.SPELL1,perso2.CD_SPELL2,false)
	emit_signal("SPELL4_CHANGED",perso2,2,perso2.SPELL2,perso2.CD_SPELL2,false)
func _process(_delta: float) -> void:
	if not can_play:return
	if is_dead:return
	if perso == null:
		return
	calculate_cd(_delta)
	controller_input()
	
	switching()
func death():
	perso.is_alive = false
	
	if persos[(choix+1)%2].is_alive:
		death_switch = true
		d0 = 1000
		
		dispawn_character(perso)
		
	else:
		is_dead = true
		get_parent().player_dead(self)
		dispawn_character(perso)
func spawn_character(new_perso,pos):
	
	new_perso.appear(self,pos)
func dispawn_character(new_perso):
	new_perso.disapear()
func switch_character():
	perso.is_controlled = false
	perso2=perso
	choix = (choix+1)%2
	perso = persos[choix]
	perso.is_controlled = true
	emit_signal("switched")
func end_switch():
	is_switch = false
	dispawn_character(persos[(choix+1)%2])
	
	
func switch(pressed,activate):
	if not activate or pressed: return
	
	if not is_switch and switch_time<=0 and Time.get_ticks_msec()-s0>2000:
		switch_time = cd_switch
		max_switch = 0
		is_switch = true
		s0 = Time.get_ticks_msec()
		spawn_pos = perso.global_position + Vector2(perso.aimX,perso.aimY)*200
		spawn_character(persos[(choix+1)%2],spawn_pos)
		switch_character()
	elif max_switch<1 and is_switch:
		max_switch+=1
		switch_character()
		SWITCH2VFX.play_at(perso.global_position)
		end_switch()

func switching():
	if is_switch and Time.get_ticks_msec()-s0>2000:
		if not perso.is_alive:
			switch_character()

		end_switch()
		
		
	
