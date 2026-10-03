extends PROJECTILE
class_name FIREBREEZ

static func create(perso,dir,force,pos):
	var inst = preload("res://Entities/Breez/FireBreez/fireBreez.tscn").instantiate()
	
	Engine.get_main_loop().current_scene.add_child(inst)
	inst.spawn(perso,dir,force,pos)
	return inst
@export var damage: int = 7


var going: bool = true
var time: float = 0.5



var start_sound = preload("res://Entities/Breez/FireBreez/sound/breez_fire.wav")
var hit_sound = preload("res://Entities/Breez/FireBreez/sound/breez_impact.wav")
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: CollisionShape2D = $Area2D/CollisionShape2D2

	
func spawn(perso,dir,force,pos) -> void:
	super(perso,dir,force,pos)
	angle_ajust = -90
	rotation = direction.angle() +deg_to_rad(angle_ajust)
	audio.stream = start_sound
	audio.play()
	animation.modulate = own.c
	
	

func _process(delta: float) -> void:
	time -= delta
	if time <= 0 and going:
		going = false
		animation.play("miss")
		velocity = Vector2.ZERO
		can_project=false
		desactivate()

	
	if not animation.is_playing() and not audio.playing:
		
		queue_free()
func project(attack,dir,force):
	super(attack,dir,force)
	rotation = dir.angle() + deg_to_rad(angle_ajust)
	
	
	
func desactivate():
	hitbox.set_deferred("disabled",true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body is ENTITY and not body is OBJECT:return
	if body.is_invincible:return
	if body.layer==layer:return
	body.take_damage(own,damage)
	audio.stream = hit_sound
	audio.play()
	going = false
	desactivate()
	animation.play("hit")
	velocity = Vector2.ZERO# Replace with function body.
