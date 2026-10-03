extends ENTITY
class_name CHOBUSHI
@onready var lance = $Lance

var atk

var contre
var is_counter = false
var contre_damage = 0
signal contre_activate

func _ready() -> void:
	super()
	
	
	hp = max_hp

	lance.ur_mine(self)
	add_state(preload("res://Entities/Chobushi/states/attack_state.gd"),"attack")
	
	add_state(preload("res://Entities/Chobushi/states/contre_state.gd"),"contre")
	add_state(preload("res://Entities/Chobushi/states/contre_end_state.gd"),"contre_end")
	add_state(preload("res://Entities/Chobushi/states/lancer_state.gd"),"lancer")
	
	change_state("idle")
func disapear():
	super()
	lance.reset()

func auto(pressed,activate):
	if not activate: return
	if pressed: return
	if locks_actions:return
	if AUTO<=0 and lance.states==0 and not current.is_busy():
		AUTO=CD_AUTO
		
		var dir = Vector2(aimX,aimY).normalized()
		lance.attack(dir)
		change_state("attack")
	elif (lance.states==1 or lance.states==2):

		lance.destroy()
	elif is_counter and not animation.is_playing():
		emit_signal("contre_activate")
		
func spell1(pressed,activate):
	
	if not activate: return
	if pressed: return
	if locks_actions:return
	if SPELL1<=0 and lance.states==0 and not current.is_busy():
		SPELL1 = CD_SPELL1
		SPELL1_USED = true
		change_state("lancer")
		var dir = Vector2(aimX,aimY).normalized()
		lance.launch(dir,1400)
	elif lance.states==1 or lance.states==2:
		lance.tp(aimX,aimY)
	elif is_counter and not animation.is_playing():
		emit_signal("contre_activate")
	
	
func spell2(pressed,activate):
	if not activate: return
	if pressed: return
	if locks_actions:return
	if SPELL2<=0 and not is_counter and not current.is_busy():
		SPELL2 = CD_SPELL2
		SPELL2_USED = true
		change_state("contre")
	elif is_counter and not animation.is_playing():
		
		emit_signal("contre_activate")
		
		
func take_damage(attacker,damage):
	if is_counter and attacker!=null:
		emit_signal("contre_activate")
		contre_damage=24
	else:super(attacker,damage)
