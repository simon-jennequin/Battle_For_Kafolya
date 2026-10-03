extends PROJECTILE
class_name GBDFBREEZ
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var start_sound = preload("res://Entities/Breez/GBDF/sound/allume.wav")
var explosion_sound = preload("res://Entities/Breez/GBDF/sound/explosion.wav")
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
var explosion = false


var damage = 20
var all_hit = []

@onready var hitbox: CollisionShape2D = $Area2D/CollisionShape2D

static func create(perso,dir,force,pos):
	var inst = preload("res://Entities/Breez/GBDF/GBDF.tscn").instantiate()
	
	Engine.get_main_loop().current_scene.add_child(inst)
	inst.spawn(perso,dir,force,pos)
	return inst
func spawn(perso,dir,force,pos):
	super(perso,dir,force,pos)
	angle_ajust = -90
	
	animation.modulate = perso.c

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 # Replace with function body.
	audio.stream = start_sound
	audio.play()

func explode():
	explosion = true
	animation.play("explosion")
	audio.stream = explosion_sound
	audio.play()
	can_project = false
	velocity = Vector2.ZERO
func destroy():
	own.SPELL2_USED = false
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if explosion and not animation.is_playing():
		
		destroy()
	if explosion and animation.frame >=2 and animation.frame<=3:
		activate()
	else:
		desactivate()

func project(attacker,dir,force):
	super(attacker,dir,force)
	velocity = dir*force
	rotation = dir.angle() + deg_to_rad(angle_ajust)
func activate():
	hitbox.set_deferred("disabled",false)
	
func desactivate():
	all_hit = []
	hitbox.set_deferred("disabled",true)
	



	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body in all_hit:return
	all_hit.append(body)
	if not body is ENTITY and not body is OBJECT:return
	if body.is_invincible:return
	if body.layer==layer:return
	
	var direction = (body.global_position-global_position).normalized()
	body.take_damage(own,25)
	body.project(own,direction,1500)# Replace with function body.


func _on_timer_timeout() -> void:
	if not explosion:explode()
