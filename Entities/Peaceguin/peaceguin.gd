extends ENTITY
class_name PEACEGUIN





var punching1
var punching2
var order = 0
var switch_up = false



var is_dash = false
var t0 = 0
const BBGUIN = preload("res://Entities/bbguin/bbguin_entity.tscn")
var mybb
signal stop_dash
signal go_punch2
const CURSOR_B = preload("res://HUD/Cursor/cursor_b.png")
const CURSOR_J = preload("res://HUD/Cursor/cursor_j.png")
const CURSOR_R = preload("res://HUD/Cursor/cursor_r.png")
const CURSOR_V = preload("res://HUD/Cursor/cursor_v.png")
@onready var cursor_bb: Sprite2D = $cursor_bb



func disapear():
	super()
	if mybb!=null:mybb.disapear()

func _ready() -> void:
	super()
	
	
	hp = max_hp
	switch = preload("res://Entities/Peaceguin/States/PeaceguinSwitch.tscn")

	add_state(preload("res://Entities/Peaceguin/States/dash_state.gd"),"dash")
	add_state(preload("res://Entities/Peaceguin/States/punch1_state.gd"),"punch1")
	add_state(preload("res://Entities/Peaceguin/States/punch2_state.gd"),"punch2")
	add_state(preload("res://Entities/Peaceguin/States/lancer_state.gd"),"lancer")
	change_state("idle")	
	
	match couleur:
		"red":cursor_bb.texture = CURSOR_R
		"blue":cursor_bb.texture = CURSOR_B
		"green":cursor_bb.texture = CURSOR_V
		"yellow":cursor_bb.texture = CURSOR_J
	
	
func _physics_process(delta: float) -> void:
	super(delta)
	if AUTO<=0:
		order=0
	if mybb!=null and not mybb.is_saved:
		print("visible")
		cursor_bb.visible=true
		cursor_bb.rotation = (global_position - mybb.global_position).angle() - deg_to_rad(40)
		if global_position.x-mybb.global_position.x<0:cursor_bb.position = Vector2(70,45)
		else:cursor_bb.position = Vector2(-70,45)
	else:cursor_bb.visible=false

			
func auto(_pressed,activate):
	
	
	if not activate: return
	if is_dash:emit_signal("stop_dash")
	if locks_actions:return
	if AUTO<=0 and order==0 and not current.is_busy():
		AUTO=CD_AUTO
		
		order=1
		t0 = Time.get_ticks_msec()
		change_state("punch1")
	elif order==1 :
		
		if not current.is_busy():
			change_state("punch2")
		else:
			emit_signal("go_punch2")
	elif is_dash:emit_signal("stop_dash")	
		
	
func spell1(pressed,activate):
	if not activate: return
	if pressed :return
	if is_dash:emit_signal("stop_dash")
	if locks_actions or locks_movements:return
	if SPELL1<=0 and not current.is_busy():
		SPELL1 = CD_SPELL1
		SPELL1_USED = true
		change_state("dash")
	
		
		
func spell2(pressed,activate):
	if not activate: return
	if pressed :return
	if is_dash:emit_signal("stop_dash")
	if locks_actions:return
	
	
	if (SPELL2<=0 or SPELL2_USED) and not current.is_busy():
		if not is_aim:aimX=direction;aimY=0
		if mybb==null:
			SPELL2 = 3
			
			mybb = BBGUIN.instantiate()
			mybb.spawn(self,game)
			game.add_child(mybb)
			mybb.parent = game
			mybb.animation.modulate = animation.modulate
			change_state("lancer")
			mybb.launch(aimX,aimY)
		elif not mybb.is_inside_tree():
			SPELL2 = 3
			
			game.add_child(mybb)
			mybb.parent = game
			mybb.animation.modulate = animation.modulate
			change_state("lancer")
			mybb.launch(aimX,aimY)
		elif mybb.is_saved:
			SPELL2 = 3
			change_state("lancer")
			mybb.launch(aimX,aimY)
		
