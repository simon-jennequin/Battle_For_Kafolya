extends OBJECT
class_name ICEWALL
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var state = 0
var t0
@onready var hitbox: Area2D = $hitbox
@onready var stream: AudioStreamPlayer2D = $stream
const WALL_CREATION = preload("res://Entities/Peaceguin/sound/wall_creation.mp3")
@onready var feet_marker: Marker2D = $feetMarker

const WALL_DESTRUCTION = preload("res://Entities/Peaceguin/sound/wall_destruction.mp3")
var couleur
var game
static func create(perso,force,dir,pos):
	var inst = preload("res://Entities/Peaceguin/wall/ice_wall.tscn").instantiate()
	
	Engine.get_main_loop().current_scene.add_child(inst)
	inst.spawn(perso,force,dir,pos)
	return inst
# Called when the node enters the scene tree for the first time.
func _ready():
	stream.stream = WALL_CREATION
	stream.pitch_scale = randf_range(0.8,1.2)
	stream.play()
	

func spawn(perso,_force,dir,pos):
	global_position = pos-feet_marker.global_position
	t0 = Time.get_ticks_msec()
	own = perso
	game = own.game
	layer = perso.layer
	
	animation.modulate = own.c
	couleur = own.couleur
	if dir.x<0:animation.flip_h=false	
	else:animation.flip_h=true

	
func destroy():
	if is_alive:
		stream.stream = WALL_DESTRUCTION
		stream.pitch_scale = randf_range(0.8,1.2)
		stream.play()
		velocity = Vector2.ZERO
		state=3
		animation.play("destruction")
		hitbox.desactivate()
		is_alive=false
		
func go_state1():
	hitbox.activate()
	state = 1
	animation.play("idle")
func go_state2():
	state = 2
	animation.play("run")
func _process(_delta: float) -> void:
	if velocity.x<0:animation.flip_h=false
	elif velocity.x>0: animation.flip_h=true
		
	if state==0 and not animation.is_playing():go_state1();
	elif state==1:
		if abs(velocity.x)!=0:go_state2()
	elif state==2:
		if abs(velocity.x)==0:go_state1()
	elif state==3 and not animation.is_playing():queue_free()

func project(_attacker,_dir,_force):
	pass
func project_peaceguin(dir,force):
	if state==0 or state==3:return
	velocity.x += force*dir
# Replace with function body.


func _on_timer_timeout() -> void:
	if state!=3:destroy()
