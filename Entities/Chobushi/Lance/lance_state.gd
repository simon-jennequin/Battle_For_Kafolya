extends PROJECTILE

var states = 0
var ending = false
var i 
var target
const distance = 200
const tp_space = 150
const SLASH = preload("res://Entities/Chobushi/sound/slash.wav")
const SLASH_HIT = preload("res://Entities/Chobushi/sound/slash_hit.wav")
const LAUNCH = preload("res://Entities/Chobushi/sound/launch.wav")
const LAUNCH_HIT = preload("res://Entities/Chobushi/sound/launch_hit.wav")
const CANCEL = preload("res://Entities/Chobushi/sound/cancel.wav")
@onready var sprite: Sprite2D = $Sprite2D

@onready var stream: AudioStreamPlayer2D = $stream

@onready var hitbox: Area2D = $hitbox_lance

var rayon = 100
func ur_mine(perso):
	own = perso
	layer = perso.layer
	sprite.modulate = own.c
func _ready() -> void:
	top_level=true
	angle_ajust = 90
	destroy()
func _physics_process(delta: float) -> void:
	
		
	if states==0:
		if own.direction<0:
			z_index=0
		else:z_index=-1 #normal
		if own.is_counter:
			visible=false
		else:
			visible=true
		
		global_position = own.global_position
		if own.is_aim: rotation = Vector2(own.aimX,own.aimY).normalized().angle()+deg_to_rad(angle_ajust)
		elif own.direction>0: rotation_degrees = 90
		else: rotation_degrees = -90
	
	elif states==1: #launch
		
		move_and_slide()
		if is_on_floor() or is_on_wall() or is_on_ceiling():
			velocity = Vector2.ZERO
		else:
			
			velocity.y+=1200*delta
			rotation = velocity.angle()+ deg_to_rad(angle_ajust)
				
		
	elif states==2:
		if is_instance_valid(target):
			if not target.is_inside_tree():launch(Vector2.ZERO,0);return
		else:launch(Vector2.ZERO,0);return
		global_position = target.global_position
		
		
	elif states==3:
		
		global_position = own.global_position + direction*rayon*(own.animation.frame+1)/4
		
	elif states==4:
		global_position = own.global_position + direction*rayon
		
	elif states==5:
		hitbox.desactivate()
		
		global_position = own.global_position + direction*rayon*(-own.animation.frame+4)/4
		
	
		
	
	
func launch(dir,force):
	layer = own.layer
	stream.stream = LAUNCH
	stream.pitch_scale = randf_range(0.8,1.2)
	stream.play()
	visible=true
	states=1
	
	speed = force
	self.direction = dir
	velocity = speed*dir
	hitbox.activate()
func attack(dir):
	layer = own.layer
	stream.stream = SLASH
	stream.pitch_scale = randf_range(0.8,1.2)
	stream.play()
	i=0
	visible = true
	states = 3
	direction=dir
	rotation = dir.angle() + deg_to_rad(angle_ajust)
	hitbox.activate()
func lock(new_target):
	layer = own.layer
	stream.stream = LAUNCH_HIT
	stream.pitch_scale = randf_range(0.8,1.2)
	stream.play()
	global_position = new_target.global_position
	target = new_target
	visible = true
	states = 2
	hitbox.desactivate()
func tp(x,y):
	SWITCH.create(own)
	var tp_stream = own.get_node("tp_stream")
	tp_stream.pitch_scale = randf_range(0.8,1.2)
	tp_stream.play()
	own.global_position = global_position +Vector2(x,y)*tp_space
	own.velocity = Vector2.ZERO
	reset()
func reset():
	if states==1 or states==2:own.SPELL1_USED = false
	visible = true
	states =0
	hitbox.desactivate()
func destroy():
	stream.stream = CANCEL
	stream.pitch_scale = randf_range(0.8,1.2)
	stream.play()
	reset()
