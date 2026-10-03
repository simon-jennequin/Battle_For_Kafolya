extends ENTITY
class_name BREEZ

@onready var lantern: Node2D = $Lantern

var aiming=false

var footstep_sounds = [

preload("res://Entities/Breez/asset/pas 1/3.wav")
,preload("res://Entities/Breez/asset/pas 1/4.wav")
]
@onready var windStream: AudioStreamPlayer2D = $windStream

var jump_sounds =preload("res://Entities/Breez/asset/pas 1/jump2.wav")
var land_sounds = [preload("res://Entities/Breez/asset/landing/land 2.wav"), preload("res://Entities/Breez/asset/landing/land 3.wav"), preload("res://Entities/Breez/asset/landing/land 4.wav")]
@onready var footstep: AudioStreamPlayer2D = $footstep
const FIRE_BREEZ = preload("res://Entities/Breez/FireBreez/fireBreez.tscn")
const GBDF = preload("res://Entities/Breez/GBDF/GBDF.tscn")
var grosse = null
var wind = preload("res://Entities/Breez/Wind/wind.tscn")
const flying_sound= preload("res://Entities/Breez/Wind/breez_wind.wav")
var flying = false
var flying_gravity =100
var before_flying = 0
var wind_direction
var rayon :=100
signal attack





func _ready() -> void:
	super()
	switch = preload("res://Entities/Breez/State/BreezSwitch.tscn")
	hp = max_hp

	add_state(preload("res://Entities/Breez/State/wind_state.gd"),"wind")
	add_state(preload("res://Entities/Breez/State/flying_state.gd"),"flying")
	change_state("idle")
func jump(pressed,activate):
	var jumping = super(pressed,activate)
	if locks_movements:return 
	if not activate:return
	if current==states["flying"] and not pressed and not jumping:
		change_state("idle")
	elif jump_count==0 and not pressed and not jumping:
		change_state("flying")

	


		

		

	
			
func auto(_pressed,activate):
	if _pressed:return
	if not activate:return
	if locks_actions:return
	if AUTO<=0 and is_aim:
		AUTO = CD_AUTO
		var direction = Vector2(aimX, aimY).normalized()
		var pos = global_position + Vector2(aimX*rayon,aimY*rayon)
		FIREBREEZ.create(self,direction,1400,pos)
		emit_signal("attack")
	elif not is_aim:
		spell1(_pressed,activate)

func spell1(pressed,activate):
	if pressed:return
	if not activate:return
	if locks_actions:return
	if SPELL1<=0.0 and not pressed:
		SPELL1 = CD_SPELL1
		
		wind_direction = Vector2(aimX,aimY).normalized()
		change_state("wind")
		
func spell2(pressed,activate):
	if pressed:return
	if not activate:return
	if locks_actions:return
	if SPELL2<=0 and grosse==null and pressed ==false:
		SPELL2 = CD_SPELL2
		SPELL2_USED = true
		var pos = global_position + Vector2(aimX*rayon,aimY*rayon)
		grosse = GBDFBREEZ.create(self,Vector2.ZERO,0,pos)
		emit_signal("attack")
	elif grosse!=null and pressed==false:
		grosse.explode()
		emit_signal("attack")
		
		
