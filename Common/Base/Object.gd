extends CharacterBody2D
class_name OBJECT

var own
var layer = 0
var team = 0
var gravite = 800
var max_hp = 30
var hp = max_hp
var is_alive=true
var is_invincible = false
var vx_before =0

signal damaged
func spawn(perso,force,dir,pos):
	own = perso
	layer = perso.layer
	team = perso.team
	global_position = pos
	velocity = force*dir
func _physics_process(delta: float) -> void:
	velocity.y+=gravite*delta
	vx_before = velocity.x
	move_and_slide()
	collision()
	
func destroy():
	if is_alive:queue_free();is_alive=false
	
func collision():
	if is_on_wall() :
		print("oui")
		velocity.x=-vx_before
func take_damage(_attacker,_damage):
	hp-=_damage
	if hp<=0:
		destroy()
	emit_signal("damaged")
func project(_attacker,_dir,_force):
	velocity = _dir*_force


		
