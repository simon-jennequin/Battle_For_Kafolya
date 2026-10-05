extends CharacterBody2D


class_name ENTITY


@export var nom:String
var is_controlled := true


var jump_force := -1200
var normal_gravity :=2000
var GRAVITY := 2000
var gravite := 1.0
var fast_fall_gravity := 6000
var fast_falling := false
@export var speed := 500
@export var jump_max := 2
@export var switchStream :AudioStreamPlayer2D
@export var switch:PackedScene
@export var footMarker:Marker2D
var moving := false

var jump_count = 2
var zone :float= 0.0


@export var animation: AnimatedSprite2D 





var is_alive = true


var current = null






@export var max_hp : float
@onready var hp:float=max_hp
var layer = 0



var vy_before


var is_aim = false


var project0 = 0
var moving_speed = 1


var aimX := 0.0
var aimY := 0.0

var locks_actions:=false
var locks_movements:=false
var locks_projections:=false
var locks_status := false
var locks_jump :=false
var is_invincible:=false
var vulnerable := 1.0
var speed_mult :float= 1.0


var friction = 1500
var frottement = 500
var project_duration = 0
var physique = true
var direction=-1
var jump0=0
var was_on_floor = false
var small_jump=false
var player
signal jumped
signal go_down
signal projected
signal damaged

var team = 0
var parent
var couleur

var status = preload("res://Common/Status_Management/Status_Manager2.gd").new()


var states = {}
var release = true
var game
@export var footstream:AudioStreamPlayer2D
@export var step_frame :Array
@export var intonation :Vector2
var step0 = 0
var vx_before
var c = Color(1,1,1)


const FOOTSTEP_TAP = preload("res://Entities/sound/footstep_tap.wav")
const JUMP_SOUND = preload("res://Entities/sound/jump.wav")
const LANDING = preload("res://Entities/sound/landing.wav")
@export var CD_AUTO:float
@export var CD_SPELL1:float
@export var CD_SPELL2:float
var AUTO:float=0.0
var SPELL1:float=0.0
var SPELL2:float=0.0
var SPELL1_USED = false
var SPELL2_USED = false

func appear(new_parent,pos):
	parent = new_parent
	SWITCHVFX.play_at(pos)
	new_parent.add_child(self)
	change_state("idle")
	global_position = pos
	velocity = Vector2.ZERO
	status.clear_all()
	project_duration=0
	
	if switchStream!=null:switchStream.play()
	
func disapear():
	change_state("idle")
	velocity = Vector2.ZERO
	status.clear_all()
	project_duration=0	
	SWITCH.create(self)
	parent.remove_child(self)
	
	
func _ready() -> void:
	add_state(preload("res://Common/State_Management/Idle.gd"),"idle")
	add_state(preload("res://Common/State_Management/run.gd"),"run")
	add_state(preload("res://Common/State_Management/jump_start.gd"),"jump_start")
	add_state(preload("res://Common/State_Management/jump_asc.gd"),"jump_asc")
	add_state(preload("res://Common/State_Management/jump_dsc.gd"),"jump_dsc")
	add_state(preload("res://Common/State_Management/jump_end.gd"),"jump_end")

	jumped.connect(func():
		if not current.is_busy():change_state("jump_start")
		
	)
	# instancie chaque état et lui passe le owner
	
	status.own = self
	
	# état initial (cohérent avec les clés, ici en minuscule)
func add_state(script,state):
	var inst = script.new()
	inst.own = self
	states[state] = inst
	inst.setup()

func init(new_layer,new_game,color,new_player,new_team):
	team = new_team
	layer = new_layer
	self.game = new_game
	player = new_player
	if not new_game.teamplay:
		if color=="red":
			c = Color(1.5,1,1)
		elif color=="blue":
			c = Color(1,1,1.5)
		elif color=="green":
			c = Color(1,1.5,1)
		elif color=="yellow":
			c = Color(1.5,1.5,1)
	if new_game.teamplay:
		
		if new_player.team==1:c = Color(1,1,1.5);couleur ="blue"
	
		if new_player.team==2:c = Color(1.5,1,1);couleur = "red"
	else:
		couleur = color
	
func change_state(state):

	var next = states[state]
	var prev = current
	if prev!=null: current.exit("")
	current = next
	current.enter(prev)

func _physics_process(delta):
	if not physique :return
	sprite()
	status.update(delta)
	
	if current!=null:
		current.update(delta)
	
	# --- CDs (corrigé : accès dictionnaire)
	
	project_duration-=delta
	if not is_on_floor():
		velocity.y += (fast_fall_gravity*gravite if fast_falling else GRAVITY*gravite) * delta
		velocity.x-=frottement*delta*velocity.normalized().x
		if project_duration>0 and Time.get_ticks_msec()-project0>120:
			EJECTVFX.play_at(global_position)
			project0 = Time.get_ticks_msec()
		if jump_count==jump_max:
			jump_count-=1
	
		
		
	elif abs(velocity.x)-friction*delta<10:
		
		velocity.x=0
	else:
		
		velocity.x-=friction*delta*velocity.normalized().x

	vy_before = velocity.y
	vx_before = velocity.x
	was_on_floor = is_on_floor()

	
	move_and_slide()
	collision()
	moving= false
	
func collision():
	if is_on_floor() and project_duration>0:
		velocity.y=-vy_before
	elif is_on_floor():
		not_down()
		jump_count = jump_max
		GRAVITY=normal_gravity
		
		if footstream!=null and not was_on_floor:
			footstream.stream = LANDING
			footstream.pitch_scale = randf_range(intonation[0],intonation[1])
			footstream.play()
	
	if is_on_wall() and project_duration>0 :
		velocity.x = -vx_before
		
	if is_on_ceiling() and project_duration>0:
		velocity.y=-vy_before


	



		
func move(dir: float):
	if locks_movements:return
	direction=dir
	if dir>0.6: direction=1
	if dir<-0.6:direction=-1
	
	moving = true

	

	# Run anim
	if is_on_floor():
		moving_speed = lerp(1.0, 3.0, abs(dir))*speed_mult
		if current==states["run"] and animation.frame in step_frame and Time.get_ticks_msec()-step0>150:
			step0 = Time.get_ticks_msec()
			
			footstream.stream = FOOTSTEP_TAP
			footstream.pitch_scale = randf_range(intonation[0],intonation[1])
			footstream.play()
		
			
	
	
	if abs(velocity.x) >speed and not abs(velocity.x)/velocity.x == abs(direction)/direction:
		velocity.x += (direction*speed)*0.01*speed_mult
	elif abs(velocity.x)<=speed:
		velocity.x = direction*speed*speed_mult



func jump(pressed,activate):
	if locks_movements or locks_jump:return false
	if release==false and activate==false:release = true
	if not activate:return false
	
	if jump_count > 0 and not pressed :
		not_down()
		jump0 = Time.get_ticks_msec()
		small_jump = true
		release = false
		emit_signal("jumped")
		fast_falling = false
		velocity.y = jump_force*0.7
		jump_count -= 1
		JUMPVFX.play_at(footMarker.global_position)
		if footstream==null:return true
		footstream.stream = JUMP_SOUND
		footstream.pitch_scale = randf_range(intonation[0],intonation[1])
		footstream.play()
		return true
	elif Time.get_ticks_msec()-jump0>50 and not release and small_jump:
		velocity.y=jump_force*0.95
		small_jump = false
	return false
		
		
func not_down():
	fast_falling = false
	set_collision_mask_value(7, true)
func down():
	if locks_movements:return
	if project_duration>0:return
	emit_signal("go_down")
	fast_falling = true
	set_collision_mask_value(7, false)
		

func _flash_red():
	var t = create_tween()
	# passe au rouge vite
	t.tween_property(animation, "self_modulate", Color(1, 0.25, 0.25, 1.0), 0.12)
	# reviens au normal
	t.tween_property(animation, "self_modulate", Color(1, 1, 1, 1), 0.18)

func death():
	DEATHVFX.play_at(global_position)
	is_alive = false
	if get_parent().has_method("death"):
		get_parent().call_deferred("death")
		
	else:
		
		call_deferred("queue_free")

	
func take_damage(_attacker,amount: int) -> void:
	if player!=null and not is_controlled and player.persos[player.choix].is_alive:
		player.end_switch()
		return
		
	
	_flash_red()
	
	var duration = 30
	if amount>10 and amount<=20:
		duration = 50
	elif amount>20:
		duration = 100
		
	   # retour normal
	
	hp -= amount*vulnerable
	
	
	if amount>10:
		Engine.time_scale = 0
		var start_time = Time.get_ticks_msec()
		while Time.get_ticks_msec() - start_time < duration:
			await get_tree().process_frame   # avance d’une frame, même avec time_scale=0
		Engine.time_scale = 1.0 
		var camera = SceneManager.get_camera()
		camera.shake(0.1,10)
	if hp<=0 and is_alive:
		hp=0
		death()
	emit_signal("damaged")

func spell1(_pressed,_activate):
	if not _activate or locks_actions:return true
	
	
func spell2(_pressed,_activate):
	if not _activate or locks_actions:return true
	
	
func auto(_pressed,_activate):
	if not _activate or locks_actions:return true
	
	
	
func aim(x,y,activate):
	if not activate or locks_actions:
		self.aimX = 0
		self.aimY = 0
		is_aim = false
		return
	is_aim = true
	self.aimX = x
	self.aimY = y
	

	
	
# --- Appliquer un knockback directement depuis un vecteur direction
func project(_attacker,dir: Vector2, force: float) -> void:
	if locks_projections:return
	not_down()
	emit_signal("projected")
	velocity = dir * force
	project_duration = force/1200
func apply_status(sta,duration,nom):
	status.apply(sta,duration,nom)
func sprite():
	var a = 1
	if not is_alive:
		a=0.6
	if is_invincible:
		animation.modulate = Color(2,2,2,a)
	elif not is_controlled:
		animation.modulate = Color(0.5,0.5,0.5,a)
	else:
		animation.modulate = Color(c.r,c.g,c.b,a)
